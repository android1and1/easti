# 2018-12-19 game is "5min=1app". 
express = require 'express'
router = express.Router()
nohm = undefined
schema = undefined
client = (require 'redis').createClient()
client.on 'error',(error)->
  console.log '::debug info - route neighborCar::',error.message
client.on 'connect',->
  md = require '../modules/md-neighborCar'
  nohm = (require 'nohm').Nohm
  nohm.setPrefix 'gaikai'
  nohm.setClient @
  schema = nohm.register md

# till here,has 'global' variable - '' 

router.get '/',(req,res,next)->
  res.redirect 302,'/neighborCar/list'

router.get '/list',(req,res,next)->
  # top10 sorted by id number.
  all = await schema.sort {field:'whatistime',limit:[0,10]} 
  allins = await schema.loadMany all 
  # allitems == all instance properties()
  allitems = []
  for ins in allins
    allitems.push ins.allProperties()
  res.render 'neighborCar/list.pug' ,{top10:allitems}
    
router.get '/register-car',(req,res,next)->
  res.render 'neighborCar/register-car.pug',{title:'Register Car(Neighbors)'}

router.get '/purge-db',(req,res,next)->
  res.render 'neighborCar/purge-db.pug'

router.delete '/purge-db',(req,res,next)->
  # quanteetee user from '/neighborCar/purge-db'(GET),click button.
  if req.xhr
    try
      await nohm.purgeDb client
    catch error
      return res.send 'purge execution failed. all.'
    
    res.send 'purge all itmes in db:wiki.'
  else
    res.send 'nosense!'

# add!
router.post '/register-car',(req,res,next)->
  ins = await nohm.factory 'neighborCar'
  body = req.body
  ins.property 'checks',1
  ins.property 
    brand:body.brand 
    licence_number: body.licence_number
    color: body.color
    vehicle_model: body.vehicle_model
    whatistime: Date.parse(new Date)
    where_seen:body.where_seen
    memo: body.memo
  try
    await ins.save()
  catch error
    console.log ins.errors
    res.send 'save failed.'
  res.send 'saved.'
  
   
  
neighborCarFactory = (app)->
  return (pathname)->
    app.use pathname,router

module.exports = neighborCarFactory 
