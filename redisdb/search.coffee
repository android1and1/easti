# first of first ,check redis-server ether running.
{spawn} = require 'child_process'

pgrep = spawn 'pgrep',['redis-server']
###
pgrep.stdout.on 'data',(chunk)->
  console.log '::PGREP::',chunk.toString 'utf-8'
###
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
      searchMatchTitle(schema,/allright/,{visits:44})
      .then (arr)->
        arr.forEach (id)->
          item = await schema.load id
          console.log item.allProperties()
  
    
# help function - search
searchMatchTitle = (nohmstaticclass,needle,opts)->
  typedesc = Object.prototype.toString.call needle
  if typedesc isnt '[object RegExp]'
    throw new Error 'Not Expected(RegExp).'
  # first check 'needle' is typeof 'ExpReg'
  # return is a promise,structed by Promise.all method
  results = []
  allids = await nohmstaticclass.find(opts)
  for id in allids
    item = await nohmstaticclass.load id   
    if /allright/.test (item.property 'about')
      results.push id
  results 
