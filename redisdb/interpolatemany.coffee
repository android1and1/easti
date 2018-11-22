{spawn} = require 'child_process'

pgrep = spawn 'pgrep',['redis-server']
#pgrep.stdout.on 'data',(chunk)->
#  console.log '::PGREP::',chunk.toString 'utf-8'
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
    rj = nohm.register (require '../modules/md-readingjournals.js')
    redis.on 'error',(err)->
      console.error '::Redis Database Error::',err.message

    redis.on 'connect',->
      nohm.setClient redis
      nohm.setPrefix 'seesee' 
      # if nessary,purge all db.
      #await nohm.purgeDb()
      for i in [1..33]
        ins = await nohm.factory 'readingjournals' 
        ins.property 'author','writter#' + i
        ins.property 'title','title#' + i
        ins.property 'journal','long long ago..'
        ins.property 'visits': i
        ins.property 'reading_history':' have a early time,reading once.'
        ins.property 'timestamp',Date.parse(new Date)
        try
          await ins.save()
        catch error
          console.log error
     
      setTimeout ->redis.quit()
        ,
        1500
        
