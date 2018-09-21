# no need http-connection
nohm = (require 'nohm').Nohm
redis = (require 'redis').createClient() # default port - 6379,default host - localhost
prefix = require '../modules/sche-tricks.js'
.prefix 

redis.on 'error',(err)->
  console.error err.message

redis.on 'connect',->
  # initial Nohm
  nohm.setClient @
  nohm.setPrefix prefix
  for i in [10..1]
    item = await nohm.factory 'tricks'
    item.property
      about:'eskoo##' + i
      content:'try4:eskoo-'+i+'step1....then\nstep2....\nstep3.....\n....end'
      visits:100 
    reply = await item.save()
    console.log 'typeof(reply) -',typeof reply
    console.log 'reply.id - ',reply.id if reply and reply?.id
    console.log 'saved item,id ' + item.id + ' its article order is ' + i
