Browser = require 'zombie'
Browser.localhost 'www.fellow6.cn',4140
browser = new Browser
app = require '../app'
fs = require 'fs'
http = require 'http'
server = http.Server app
server.listen 4140
server.on 'error',(err)->console.error err

# sometimes it will help(below line),especially beaglebone and raspi
browser.waitDuration = '30s'
describe 'route - "/neighborCar/list/"::',->
  # need by raspberry pi,even version 2
  @timeout 9140
  after ->
    server.close()
  describe 'base functional::',->
    before ->
      browser.visit 'http://www.fellow6.cn/'
    it 'should access page successfully::',->
      browser.assert.success()
      browser.assert.status 200
      #console.log browser.html()
