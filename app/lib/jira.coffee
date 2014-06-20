qrequest = require './qrequest'

baseUri = '/rest/api/2'

class Jira
  @epicKeyFieldName: 'customfield_11530'
  @epicNameFieldName: 'customfield_11531'

  constructor: (@host) ->

  json: (uri, qs) ->
    qrequest url: @host + uri, qs: qs, json: true
      .then (response) -> response.body

  projects: ->
    @json "#{baseUri}/project"

  project: (projectKey) ->
    @json "#{baseUri}/project/#{projectKey}"

  projectVersions: (projectKey) ->
    @json "#{baseUri}/project/#{projectKey}/versions"

  version: (versionId) ->
    @json "#{baseUri}/version/#{versionId}"

  jql: (opts) ->
    opts.maxResults ||= 1000
    @json "#{baseUri}/search", opts

  epics: (projectKey, versionId) ->
    @jql
      jql: "project=#{projectKey} and fixVersion=#{versionId} and
            issueType=epic"
      fields: "#{Jira.epicNameFieldName},summary"

  issues: (projectKey, versionId) ->
    @jql
      jql: "project=#{projectKey} and fixVersion=#{versionId} and
            issueType!=epic"
      fields: "summary,resolution,#{Jira.epicKeyFieldName}"
      expand: 'changelog'

module.exports = Jira
