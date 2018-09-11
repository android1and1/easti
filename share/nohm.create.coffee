nohm = (require 'nohm').Nohm
redis = (require 'redis').createClient()
redis.on 'connect',->
  console.log 'connected.'
  nohm.setClient redis
  User = require './schema.coffee' 
  nohm.setPrefix 'oneofnohm'
  user = new User
  user.property
    name:'liu bei'
    email:'chuanyue@sanguo.com'
    password:'you know already'
    visits:10001
  try
    await user.save()
    console.log 'saved!'
  catch error
    console.log user.errors
  ids = await User.find()
  console.log ids
