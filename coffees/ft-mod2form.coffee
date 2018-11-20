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
describe 'Include /alpha/sample-html2form::',->
  describe 'basically::',->
    before ->
      # browser support listen event
      #browser.on 'active',(window)->console.log window.innerWidth,'pixes.'
      browser.visit 'http://www.cinema.com/alpha/sample-html2form'
    it 'should be accessible::',->
      browser.assert.success()
  describe 'submit postfix::',->
    flag = false
    before ->
      browser.on 'submit',(event,target)->
        console.log 'trigger %s event,target is %s.',event,target
        flag = ! flag
      browser.pressButton '.idoido'
    it 'should trigger ajax submit::',->
      assert.equal flag,true
