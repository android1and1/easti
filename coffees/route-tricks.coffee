fs = require 'fs'
pug = require 'pug'
path = require 'path'
express = require 'express'
router = express.Router()
formidable = require 'formidable'
Redis = require 'redis'
nohm = (require 'nohm').Nohm
schema = require '../modules/sche-tricks.js'
DB_PREFIX = schema.prefixes[0] 
TABLE_PREFIX = schema.prefixes[1]
 
#counter
counter = 0

# the first time,express working with nohm - redis orm library
router.get  '/',(req,res,next)->
  redis = Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-tricks::',err.message
  redis.on 'connect',->
    nohm.setClient redis
    nohm.setPrefix DB_PREFIX
    ids = await schema.find() 
    items = []
    if ids.length > 0
      for i in ids
        item = await schema.load i
        items.push item.allProperties()
      res.render 'tricks/index.pug',{length:items.length,items:items}
    else
      res.render 'tricks/index.pug',{idle:true}
router.get '/add',(req,res,next)->
  res.render 'tricks/add.pug',{order:counter++}

router.post '/add',(req,res,next)->
  redis = Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-tricks::',err.message
  redis.on 'connect',->
    nohm.setClient redis
    nohm.setPrefix DB_PREFIX
    if req.body.sign is '1'
      response = await handSingle req.body
      return res.json response 
    else
      response = await handArray parseInt(req.body.sign),req.body
      return res.json response

router.post '/onemore',(req,res,next)->
  #note that,"pug.renderFile" retrieves .pug path,not same as "res.render"
  # res.render works from root directory - "<project>/views"
  res.send pug.renderFile 'views/tricks/snippet-form.pug',{order:counter++}

###
help methods
###

handSingle = (body)->
  trick = await nohm.factory TABLE_PREFIX 
  trick.property
    about:body.about
    content:body.content
    visits:body.visits
    moment:Date.parse new Date()
  valid = await trick.validate(undefined,false)
  if not valid 
    #console.dir trick.errors
    # return a promise
    showtitle = 'handle item about "' + body.about + '"'
    return Promise.resolve 
      showtitle:'failure due to database suit'
      errors: trick.errors 
  else
    trick.save().then ->
      showtitle = 'handle item "' + trick.id + ' " completed.'
      return Promise.resolve showtitle

handArray = (length,body)->
  allthings = [0...length].map (i)->
    handSingle 
      about:body["about"][i] 
      content:body["content"][i]
      visits:body["visits"][i]
  Promise.all allthings
module.exports = router
