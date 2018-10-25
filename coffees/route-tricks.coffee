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
router.get '/add1',(req,res,next)->
  res.render 'tricks/add1.pug',{order:counter++}

router.post '/add1',(req,res,next)->
  redis = Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-tricks::',err.message
  redis.on 'connect',->
    nohm.setClient redis
    nohm.setPrefix DB_PREFIX
    if req.body.sign is '1'
      check = await handSingle req.body
      if check.error  # has error
        return res.json {state:'Error'}
      else
        return res.json {state:'Saved'}
    else
      #res.json 'state':'you has given ' + req.body.sign + ' forms,wait our resolving.'
      return res.json 'meiyou':'shi qing!'
      #handArray res,req.body

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
  valid = await trick.validate(undefined,false)
  console.log 'inner help func::handSingle',valid
  if not valid 
    console.dir trick.errors
    # return a promise
    return Promise.resolve {error:true}
  else
    trick.save().then ->
      return Promise.resolve {error:false}

handArray = (length,body)->
  for i in [0...length]
    handSingle res
      ,
      about:body[i]["about"] 
      content:body[i]["content"]
      visits:body[i]["visits"]
module.exports = router
