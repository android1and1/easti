nohm = (require 'nohm').Nohm
redis = (require 'redis').createClient() # default port - 6379,default host - localhost
schema = require '../modules/sche-tricks.js'
redis.on 'error',(err)->
  console.error err.message

redis.on 'connect',->
  # initial Nohm
  nohm.setClient @
  nohm.setPrefix schema.prefix
  ids = await schema.find()
  for id in ids
    item = await schema.load id
    console.log item.allProperties() 
