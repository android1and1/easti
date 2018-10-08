fs = require 'fs'
pug = require 'pug'
path = require 'path'
express = require 'express'
router = express.Router()
formidable = require 'formidable'
Redis = require 'redis'
nohm = (require 'nohm').Nohm
schema = require '../modules/sche-tricks.js'
PREFIX = 'EastI'

# the first time,express working with nohm - redis orm library
router.get  '/',(req,res,next)->
  redis = Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-tricks::',err.message
  redis.on 'connect',->
    nohm.setClient redis
    nohm.setPrefix PREFIX
    ids = await schema.find() 
    items = []
    if ids.length > 0
      for i in ids
        item = await schema.load i
        items.push item.allProperties()
      res.render 'tricks/index.pug',{length:items.length,items:items}
    else
      res.render 'tricks/index.pug',{idle:true}
router.get '/add1',(req,res,next)->
  redis = Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-tricks::',err.message
  redis.on 'connect',->
    nohm.setClient redis
    nohm.setPrefix PREFIX
    ids = await schema.find() 
    # TODO
  res.render 'tricks/add1.pug',{order:0}

router.post '/add1',(req,res,next)->
  #dummy
  #res.render 'tricks/successfully.pug',{title:'tricks-successfully',status:'still ok'}
  console.dir req.body
  resp = {} 
  for i,v of req.body
    resp[i] = v
  res.json resp
    

router.post '/onemore',(req,res,next)->
  #note that,pug.renderFile retrieves .pug path,not same as pug.render(from root directory:<project>/views
  res.send pug.renderFile 'views/tricks/snippet-form.pug'

module.exports = router
