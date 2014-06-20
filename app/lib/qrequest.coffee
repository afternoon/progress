Q = require 'q'
request = require 'request'

okStatusCodes =
  GET: [200]
  HEAD: [200]
  PUT: [200, 201]
  POST: [200, 201]
  DELETE: [200, 201]

module.exports = (req) ->
  deferred = Q.defer()
  method = req.method || 'GET'

  request req, (error, response, body) ->
    if error
      deferred.reject error
    else if okStatusCodes[method].indexOf(response.statusCode) == -1
      deferred.reject response
    else
      deferred.resolve response

  deferred.promise
