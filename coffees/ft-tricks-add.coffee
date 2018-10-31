# tricks is route for 'saving/updating/deleting/finding' tricks-db (a nohm-like database)

# first check if redis-server is running,if at macbook air,it is not running as a service
# we should manually start it,
# in this standalone test,we can run "redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"

assert = require 'assert'
Browser = require 'zombie'
Browser.localhost 'www.fellow5.cn',4140
browser = new Browser()
browser.waitDuration = '30s'
app = require '../app.js'
server = (require 'http').Server app

{ spawn } = require 'child_process'
pgrep = spawn '/usr/bin/pgrep',['redis-server','-l']
pgrep.on 'close',(code)->
  #console.log 'pgrep inspect redis-server process is:',code
  if code isnt 0
    tellAndExit()
tellAndExit = ->
  console.log 'You MUST start redis-server ./redisdb/redis.conf first(special for apple macbook air user).'
  console.log 'alternatively,can run this:'
  console.log '\t\t"redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"'
  process.exit 1
server.on 'error',(err)->
  console.log '///////'
  console.error err
  console.log '///////'

server.listen 4140
    
describe 'it will be successfully while accessing /tricks/add::',->
  before ()->
    browser.visit 'http://www.fellow5.cn/tricks/add'
  after ->
    server.close()
  it 'it will be success while accessing route - /tricks/add::',->
    browser.assert.success()
    browser.assert.status 200
  it 'page has a div its id is deadline::',->
    browser.assert.element 'div#deadline'
  it 'The 3 fields  all have its name attribute::',->
    browser.assert.elements '.form-control[name]',3
  it 'The form action is same url.href and method is POST::',->
    browser.assert.attribute 'form','action',''
    browser.assert.attribute 'form','method','POST'
  it 'at first time there just one "+1" button::',->
    browser.assert.elements 'button.onemore',1 
  it.skip 'click +1 button one time,the button.onemore elements has 2::',(done)->
    browser.pressButton '+ 1',->
      browser.assert.elements 'button.onemore',2
      done()

  describe 'submit form::',->
    before -> 
      browser.fill '[name=content]','there was a game between county a and country b,\nlong long ago..'
      browser.fill '[name=about]','aboutone'
      browser.fill '[type=number]','1111'
      browser.pressButton 'button' 
    it 'should ajax get new element - "div.alert.alert-info"::',->
      browser.assert.element 'div.alert.alert.alert-info'
