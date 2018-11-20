Browser = require 'zombie'
http = require 'http'
assert = require 'assert'
Browser.localhost 'www.cinema.com',4140
browser = new Browser
browser.waitDuration = '30s'

app = require '../app.js'
server = http.Server app
server.on 'error',(error)->
  console.log 'during test occurs *error*::'
  console.error error.message

server.listen 4140


# start assertions.
describe 'Router Functional Test -  /reading-journals::',->
  describe 'basically::',->
    before ->
      browser.visit 'http://www.cinema.com/reading-journals/'
    it 'should be accessible::',->
      browser.assert.success()
