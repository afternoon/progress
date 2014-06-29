express = require 'express'
morgan = require 'morgan'

progressData = require './progressData'

errorHandlerFactory = (res) ->
  (response) ->
    console.error response
    res.json response.statusCode, response.body.errorMessages

appFactory =
  build: (jira) ->
    app = express()

    app.use morgan()
    app.use express.static __dirname + '/../www'

    app.get '/projects', (req, res) ->
      jira.projects().then(
        (projects) -> res.json projects
        errorHandlerFactory(res)
      )

    app.get '/projects/:projectKey', (req, res) ->
      jira.project(req.params.projectKey).then(
        (project) -> res.json project
        errorHandlerFactory(res)
      )

    app.get '/projects/:projectKey/versions/:versionId', (req, res) ->
      err = errorHandlerFactory(res)
      version = undefined
      epicData = undefined
      issueData = undefined

      jira.version(req.params.versionId).then(
        (response) ->
          version = response
          jira.epics(req.params.projectKey, req.params.versionId)
        err
      ).then(
        (response) ->
          epicData = response
          jira.issues(req.params.projectKey, req.params.versionId)
        err
      ).then(
        (response) ->
          issueData = response
          res.json progressData.versionProgress(version, epicData, issueData)
        err
      )

    app

module.exports = appFactory
