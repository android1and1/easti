Browser = require 'zombie'
Browser.localhost 'example.com',4140
browser = new Browser
app = require '../app'
http = require 'http'
http.Server app
app.listen 4140
# sometimes it will help(below line)
#browser.waitDuration = '30s'
describe 'zombie ability display::',->
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
