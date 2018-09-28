# first check if redis-server is running,if at macbook air,it is not running as a service
# we should manually start it,
# in this standalone test,we can run "redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"
{ spawn } = require 'child_process'
pgrep = spawn '/usr/bin/pgrep',['redis-server','-l']
pgrep.on 'close',(code)->
  if code isnt 0
    console.log 'should start redis-server ./redisdb/redis.conf first(special for apple macbook air user).'
    console.log 'alternatively,can run this:'
    console.log '\t\t"redis-server ./redisdb/redis.conf && mocha <this-test-script.js>"'
    process.exit 1

assert = require 'assert'
redis = require 'redis'
.createClient()
nohm = require 'nohm'
.Nohm

schema = nohm.model 'trythem'
  ,
    idGenerator:'increment'
    ,
    properties:
      tryabout:
        type:'string'
        validations:['notEmpty']
        unique:true
      trycontent:
        type:'string'
        validations:['notEmpty']
      trymoment:
        type:'timestamp'
        defaultValue:Date.parse new Date
      tryvisits:
        type:'integer'
        index:true
        defaultValue:0 


describe 'custom function try test::',->
  before ->
    nohm.setPrefix 'tryNohm'
    nohm.setClient redis
    db = await nohm.factory 'trythem'
    db.property 'tryabout','story1'
    db.property 'trycontent','long long ago\nthere was a ..\n'
    db.property 'tryvisits',2222
    try
      return db.save()
    catch error  
      return Promise.resolved 'be catched:::' + error
  after ->
    # clean all,via node-redis
    redis.keys 'tryNohm*',(err,keylist)->redis.del key for key in keylist 
  it 'should create 1 item::',->
    # find() will list all items.
    db = await nohm.factory 'trythem' 
    ids = await db.find()
    assert.equal ids.length,1
  it 'should correct attribute of saved object::',->
    db = await nohm.factory 'trythem'
    db.load 1
    .then (something)->
      assert.equal something.tryvisits,2222
      # or
      #assert.equal db.allProperties().tryvisits,2222
  it 'should create 2nd item::',->
    db = new schema
    db.property 
      tryabout:'story2'
      trycontent:'same story,from\nlong long ago...\n'
      tryvisits:1200
 
    db.save().then ->
      db.find().then (list)->
        assert.equal list.length,2
  it 'should find story2 item::',->
    db = await nohm.factory 'trythem'
    idlist = await db.find {tryvisits:{max:2000}}
    theid = idlist[0]
    obj = await db.load theid
    assert.equal obj.tryabout,'story2'
    
