nohm = require 'nohm'
.Nohm
redis = (require 'redis').createClient() # default 6379 port redis-cli
# include our Model
schema = require '../modules/sche-tricks'
DBPREFIX = schema.prefixes[0]
HASHPREFIX = schema.prefixes[1]
console.log schema.prefixes
redis.on 'error',(err)->
  console.error err.message

redis.on 'connect',->
  nohm.setClient redis
  nohm.setPrefix DBPREFIX
  
  ins = await schema.load 1
  ins.property 'about','more time'
  console.log 'ok',ins.allProperties()
