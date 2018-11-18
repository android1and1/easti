# first of first ,check redis-server ether running.
{spawn} = require 'child_process'

pgrep = spawn 'pgrep',['redis-server']
pgrep.stdout.on 'data',(chunk)->
  console.log '::PGREP::',chunk.toString 'utf-8'
pgrep.on 'error',(error)->
  console.log 'found error during child proces.'
  
pgrep.on 'close',(code)->
  if code isnt 0
    console.log 'redis-server is *NOT* running,exit process.'
    process.exit 1
  else
    nohm = (require 'nohm').Nohm
    redis = (require 'redis').createClient() # default 6379 port redis-cli
    # include our Model
    schema = require '../modules/sche-tricks'
    DBPREFIX = schema.prefixes[0]
    HASHPREFIX = schema.prefixes[1]
    redis.on 'error',(err)->
      console.error '::Redis Database Error::',err.message

    redis.on 'connect',->
      nohm.setClient redis
      nohm.setPrefix DBPREFIX
      for i in [1..3]
        ins = await nohm.factory HASHPREFIX
        ins.property 'about','notallrightno' + i
        ins.property 'content','long long ago..'
        ins.property 'visits',44
        ins.property 'moment',Date.parse(new Date)
        ins.save().then (saved)->console.log saved
