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
    redis.keys '*',(err,keylist)->redis.del key for key in keylist 
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
