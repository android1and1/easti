redis = require 'redis'
util = require 'util'

client = redis.createClient()

client.on 'error',(e)->console.error 'Error Message::' + e.message

client.on 'end',->
  console.log 'Common Exit.'

client.auth 'averyveryveryveryverylongpassword.',(err)->
  client.keys 'ticket:*',(e,list)->
    console.log i for i in list
    client.quit()
