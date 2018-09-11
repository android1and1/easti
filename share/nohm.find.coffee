nohm = (require 'nohm').Nohm
redis = (require 'redis').createClient()
redis.on 'connect',->
  console.log 'connected.'
  nohm.setClient redis
  User = require './schema.coffee' 
   
  nohm.setPrefix 'oneofnohm'
  ids = await User.find()
  user = new User
  console.log ids[0]
  properties = await user.load ids[0]
  for index,attr of properties
    console.log index,':',attr
