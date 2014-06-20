appFactory = require './AppFactory'

class App
  constructor: (jira, port) ->
    @port = port || 3000
    @app = appFactory.build(jira)

  start: ->
    @app.listen @port, =>
      console.log 'Listening on port %d', @port

module.exports = App
