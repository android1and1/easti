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
  
      # really 
      trick = await nohm.factory 'tricks' 

      ids = await trick.sort
        field:'about'
        direction:'DESC'
        limit:[17]
      console.log 'desc sort:',ids.length,ids
      ids = await trick.sort
        field:'visits'
        limit:[17]
      console.log 'alpha sort:',ids.length,ids
