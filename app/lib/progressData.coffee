_ = require 'lodash'
Jira = require './jira'

progressData =
  versionEpicIndex: (epicData) ->
    _.object epicData.issues.map (epic) -> [
      epic.key
      key: epic.key
      name: epic.fields[Jira.epicNameFieldName]
      summary: epic.fields.summary
      issues: []
    ]

  addIssuesToVersionEpicIndex: (epicIndex, issueData) ->
    _.each issueData.issues, (issue) ->
      epicKey = issue.fields[Jira.epicKeyFieldName]
      if epicIndex.hasOwnProperty(epicKey)
        props =
          key: issue.key
          summary: issue.fields.summary
          resolved: issue.fields.resolution != null
        epicIndex[epicKey].issues.push props
    epicIndex

  addIssueCounts: (epicIndex) ->
    _.each epicIndex, (epic) ->
      epic.resolved = _.filter epic.issues, resolved: true
      epic.unresolved = _.filter epic.issues, resolved: false
      epic.issueCounts =
        resolved: epic.resolved.length
        unresolved: epic.unresolved.length
        total: _.size(epic.issues)
    epicIndex

  versionEpics: (epicData, issueData) ->
    @addIssueCounts(@addIssuesToVersionEpicIndex(
      @versionEpicIndex(epicData), issueData))

  versionProgress: (version, epicData, issueData) ->
    id: version.id
    name: version.name
    epics: @versionEpics epicData, issueData

module.exports = progressData
