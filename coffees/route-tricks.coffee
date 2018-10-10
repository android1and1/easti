fs = require 'fs'
pug = require 'pug'
path = require 'path'
express = require 'express'
router = express.Router()
formidable = require 'formidable'
Redis = require 'redis'
nohm = (require 'nohm').Nohm
schema = require '../modules/sche-tricks.js'
DB_PREFIX = 'EastI'
TABLE_PREFIX = schema.prefix
 
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
    trick = await nohm.factory TABLE_PREFIX
    # the first time,we handle the easiest case:one form
    #console.dir req.body
    trick.property
      about:req.body.about
      content:req.body.content
      visits:req.body.visits
    valid = await trick.validate(undefined,false)
    console.log 'valid==',valid
    if not valid
      res.json {errors:trick.errors,debuginfo:'debug info - wrong!'}
    else
      trick.save().then ->
        res.json
          'state':'saved'

router.post '/onemore',(req,res,next)->
  #note that,"pug.renderFile" retrieves .pug path,not same as "res.render"
  # res.render works from root directory - "<project>/views"
  res.send pug.renderFile 'views/tricks/snippet-form.pug',{order:counter++}

module.exports = router
