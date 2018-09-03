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
    it 'all input fields  has its name attribute::',->
      browser.assert.elements 'input[name]',2
      browser.assert.attribute 'input','name',/\w+/
    describe 'submits form::',->
      before ()-> 
        browser.fill('input[type="text"]','any thing here')
        browser.check('input[name="ifenc"]')
        return browser.pressButton('Upload Now')
      it 'while fields full submit will cause redirect to new url::',->
        browser.assert.redirected()
      it 'new title "iphone-uploading-success" will occurs::',->
        browser.assert.text 'title','iphone-uploading-success' 
