# 2018-12-19 game is "5min=1app".
express = require 'express'
router = express.Router()
nohm = undefined
client = (require 'redis').createClient()
client.on 'error',(error)->
  console.log '::debug info - route neighborCar::',error.message
client.on 'connect',->
  md = require '../modules/md-neighborCar'
  nohm = (require 'nohm').Nohm
  nohm.setPrefix 'wiki'
  nohm.setClient @
  nohm.register md

# till here,has 'global' variable - '' 

router.get '/',(req,res,next)->
  res.send 'i am neighbor car router.'

router.get '/register-car',(req,res,next)->
  res.render 'neighborCar/register-car.pug',{title:'Register Car(Neighbors)'}

router.post '/register-car',(req,res,next)->
  ins = await nohm.factory 'neighborCar'
  ins.property 
    brand:'tokyo'
    licence_number:'1a44b'
    color:'white'
    vehicle_model:'yueye'
    whatistime:'2017-11-2 18:04:19'
    memo:'a man within a black coat.'
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
