Browser = require 'zombie'
Browser.localhost 'example.com',4140
browser = new Browser
app = require '../app'
fs = require 'fs'
http = require 'http'
server = http.Server app
server.listen 4140
server.on 'error',(err)->console.error err

# sometimes it will help(below line),especially beaglebone and raspi
browser.waitDuration = '30s'
describe 'route - "/uploading"::',->
  # need by raspberry pi,even version 2
  @timeout 9140
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
    it 'has one textarea field and it has name attribute::',->
      browser.assert.elements 'textarea[name]',1
      browser.assert.attribute 'textarea','name',/\w+/
    it 'all input fields  has its name attribute::',->
      browser.assert.elements 'input[name]',2
      browser.assert.attribute 'input','name',/\w+/
    describe 'submits form::',->
      before ()-> 
        # before() be resolved by mocha,and mocha executes from <project-root>
        thepath = fs.realpathSync './package.json'
        
        browser.fill 'textarea[name=specof]','formidable:A Node.js module for parsing form data,especially file uploads.\nThis module was developed for transloadit.com,a service forcused on uploading.'
        browser.attach 'input[type="file"]',thepath
        browser.check('input[name="ifenc"]')
        return browser.pressButton('Upload Now')
      it 'while fields full submit will cause redirect to new url::',->
        browser.assert.redirected()
      it 'new title "iphone-uploading-success" will occurs::',->
        browser.assert.text 'title','iphone-uploading-success' 
