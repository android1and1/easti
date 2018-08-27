# just test zombie + mocha enviroment
http = require 'http'
app = require '../app.js' 
server = http.Server app
server.listen 3004,'localhost'
Browser = require 'zombie'
Browser.localhost 'example.com',3004 #3003 is development specail port
browser = new Browser
describe 'access site index page is easy::',->
  before (done)->
    browser.visit 'example.com',done
  it 'should access page successfully::',->
    browser.assert.success()
  it 'page title is "you see you"::',->
    browser.assert.text 'title','I see you' 
