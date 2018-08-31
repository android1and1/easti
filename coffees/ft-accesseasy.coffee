Browser = require 'zombie'
Browser.localhost 'example.com',4140
browser = new Browser
app = require '../app'
http = require 'http'
server = http.Server app
server.listen 4140
server.on 'error',(err)->console.error err

# sometimes it will help(below line)
#browser.waitDuration = '30s'
describe 'zombie ability display::',->
  after ->
    server.close()
  describe 'access index page should success::',->
    before ->
      browser.visit 'http://example.com'
    it 'should access page successfully::',->
      browser.assert.success()
      #No Need This Time
      #console.log browser.html()
    it 'should has 2 h4 tags::',->
      browser.assert.elements 'h4',2
    it 'page title is "I see You"::',->
      browser.assert.text 'title','I see You' 
  describe 'access alpha route test page(alpha-1) should success::',->
    before ->
      browser.visit 'http://example.com/alpha/alpha-1'
    it 'should access access successfully::',->
      browser.assert.success()
      browser.assert.status 200
