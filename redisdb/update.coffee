# first of first ,check redis-server ether running.
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
    schema = nohm.register (require '../modules/md-readingjournals.js')
    redis.on 'error',(err)->
      console.error '::Redis Database Error::',err.message

    redis.on 'connect',->
      nohm.setClient redis
      nohm.setPrefix 'seesee' 
      # really 
      try
        id1 = await schema.load 1
        id1.property 'author','itisme!'
        try
          await id1.save
            silence:true
        catch error2
          if error2 instanceof nohm.ValidationError
            console.log 'validation error,because:',error2.errors
          else
            console.log 'Error While Saving.'
      catch error1
        console.log 'Catched:',error1.message
      redis.quit()
