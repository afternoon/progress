require 'angular/angular'
require 'angular-route/angular-route'
moment = require 'moment'

projectDataFactory = require './projectDataFactory.coffee'

baseUrl = ''

app = angular.module 'progress', ['ngRoute']

projectDataFactory.build(app, baseUrl)

app.config ($routeProvider) ->
  $routeProvider
    .when '/projects',
      controller: 'projectListCtrl'
      templateUrl: 'projectList'
    .when '/projects/:projectKey',
      controller: 'projectVersionListCtrl'
      templateUrl: 'projectVersionList'
    .when '/projects/:projectKey/versions/:versionId',
      controller: 'projectVersionDashboardCtrl'
      templateUrl: 'projectVersionDashboard'
    .otherwise redirectTo: '/projects'

app.controller 'projectListCtrl', [
  '$scope',
  'projectData',
  ($scope, projectData) ->
    projectData
      .projects()
      .then (projects) ->
        $scope.projects = projects
]

app.controller 'projectVersionListCtrl', [
  '$scope',
  '$routeParams',
  'projectData',
  ($scope, $routeParams, projectData) ->
    projectData
      .project $routeParams.projectKey
      .then (project) ->
        $scope.project = project
]

app.controller 'projectVersionDashboardCtrl', [
  '$scope',
  '$routeParams',
  'projectData',
  ($scope, $routeParams, projectData) ->
    $scope.date = moment().format('DD MMM YYYY')
    projectData
      .project $routeParams.projectKey
      .then (project) ->
        $scope.project = project
        projectData
          .version $routeParams.projectKey, $routeParams.versionId
          .then (version) ->
            $scope.version = version
]
