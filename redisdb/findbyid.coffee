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
    schema = nohm.register (require '../modules/md-readingjournals')
    redis.on 'error',(err)->
      console.error '::Redis Database Error::',err.message

    redis.on 'connect',->
      nohm.setClient redis
      nohm.setPrefix 'seesee' 
  
      # really 
      journal = await nohm.factory 'readingjournals' 

      ids = journal.find 
        title:'book#a4'
         
      ids.then (val)->
        if val.length is 0
          console.log 'no found.'
        else
          console.log 'found info is:',val
        redis.quit()
