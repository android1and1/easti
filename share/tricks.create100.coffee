# no need http-connection
nohm = (require 'nohm').Nohm
redis = (require 'redis').createClient() # default port - 6379,default host - localhost
db_tricks = require '../modules/sche-tricks'
prefix = 'TryMoment' 

redis.on 'error',(err)->
  console.error 'display redis and nohm error(s)....'
  console.error err.message

redis.on 'connect',->
  # initial Nohm
  nohm.setClient @
  nohm.setPrefix prefix
  for i in [1..100]
    item = await nohm.factory 'tricks'
    item.property
      about:'thisisitem##' + i
      content:'line1...\nline2...\nlong long ago,there was an old\nsomething..end\n'
      visits:1000 
    reply = await item.save()
    console.log 'saved item,id ' + item.id + ' its article order is ' + i
  process.nextTick ->redis.quit (code)->console.log 'exit redis-client connection with code:',code
