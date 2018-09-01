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
describe 'route - "/uploading"::',->
  after ->
    server.close()
  describe 'iphone-uploading sub router::',->
    before ->
      browser.visit 'http://example.com/uploading/iphone-uploading'
    it 'should access page successfully::',->
      browser.assert.success()
      browser.assert.status 200
      #No Need This Time
      #console.log browser.html()
