_ = require 'lodash'

projectDataFactory =
  build: (app) ->
    app.factory 'projectData', ['$http', ($http) ->
      get = (url) ->
        $http
          .get url
          .then (response) -> response.data

      projects: ->
        get '/projects'

      project: (projectKey) ->
        get "/projects/#{projectKey}"

      version: (projectKey, versionId) ->
        get "/projects/#{projectKey}/versions/#{versionId}"
    ]

module.exports = projectDataFactory
