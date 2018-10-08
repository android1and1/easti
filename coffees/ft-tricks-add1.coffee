# tricks is route for 'saving/updating/deleting/finding' tricks-db (a nohm-like database)

# first check if redis-server is running,if at macbook air,it is not running as a service
# we should manually start it,
# in this standalone test,we can run "redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"
checkifredisserverisrunning = ->
  { spawn } = require 'child_process'
  return new Promise (resolve)->
    pgrep = spawn '/usr/bin/pgrep',['redis-server','-l']
    pgrep.on 'close',(code)->
      if code isnt 0
        resolve true 
      else
        resolve false
tellAndExit = ->#
  console.log 'should start redis-server ./redisdb/redis.conf first(special for apple macbook air user).'
  console.log 'alternatively,can run this:'
  console.log '\t\t"redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"'
  process.exit 1

Browser = require 'zombie'
Browser.localhost 'www.fellow5.cn',4140
browser = new Browser
browser.waitDuration = '30s'
app = require '../app.js'
server = (require 'http').Server app

server.on 'error',(err)->
  console.log '///////'
  console.error err
  console.log '///////'

server.listen 4140

describe 'it will be successfully while accessing /tricks/add1::',->
  before ()->
    bool = await checkifredisserverisrunning()
    if bool
      tellAndExit() 
    browser.visit 'http://www.fellow5.cn/tricks/add1'
  after ->
    server.close()
  it 'it will be success while accessing route - /tricks/add1::',->
    browser.assert.success()
    browser.assert.status 200
  it 'The 3 fields  all have its name attribute::',->
    browser.assert.elements '.form-control[name]',3
  it 'The form action is same url.href and method is POST::',->
    browser.assert.attribute 'form','action',''
    browser.assert.attribute 'form','method','POST'
  it 'has a "onemore" button::',->
    browser.assert.element 'button#onemore' 

  describe 'submit form::',->
    before -> 
      browser.fill '[name=content]','there was a game between county a and country b,\nlong long ago..'
      browser.fill '[name=about]','aboutone'
      browser.fill '[type=number]','1111'
      browser.pressButton 'button' 
    it 'should be redircted to /tricks/successfully page::',->
      browser.assert.success()
      browser.assert.text 'title','tricks-successfully'
    it 'should add 1 item::',->
