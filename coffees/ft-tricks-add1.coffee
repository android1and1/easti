# tricks is route for 'saving/updating/deleting/finding' tricks-db (a nohm-like database)
Redis = require 'redis'
redis = Redis.createClient()

redis.on 'connect',->
  # tell how many items about '*:hash:tricks:*'
  redis.keys '*:hash:tricks:*',(err,list)->
    for item in list
      console.log item
Browser = require 'zombie'
Browser.localhost 'www.fellow5.cn',4140
browser = new Browser
browser.waitDuration = '30s'
app = require '../app.js'
server = (require 'http').Server app

server.on 'error',(err)->
  console.error 'start debug error info::'
  console.error err
  console.error 'debug error info end::'

server.listen 4140

describe 'it will be successfully while accessing /tricks/add1::',->
  before (done)->
    browser.visit 'http://www.fellow5.cn/tricks/add1',done 
  after ->
    server.close()
    redis.quit() # close db connection
  it 'it will be success while accessing route - /tricks/add1::',->
    browser.assert.success()
    browser.assert.status 200
  it 'The 3 fields  all have its name attribute::',->
    browser.assert.elements '.form-control[name]',3
  it 'The form action is same url.href and method is POST::',->
    browser.assert.attribute 'form','action',''
    browser.assert.attribute 'form','method','POST'

  describe 'submit form::',->
    before -> 
      browser.fill 'textarea','there was a game between county a and country b,\nlong long ago..'
      browser.fill '[name=about]','aboutone'
      browser.fill '[type=number]','1111'
      browser.pressButton 'button' 
    it 'should be redircted to /tricks/successfully page::',->
      browser.assert.success()
      browser.assert.text 'title','tricks-successfully'
    it 'should add 1 item::',->
      
