fs = require 'fs'
pug = require 'pug'
path = require 'path'
express = require 'express'
router = express.Router()
formidable = require 'formidable'

schema = require '../modules/sche-tricks.js'
DB_PREFIX = schema.prefixes[0] 
TABLE_PREFIX = schema.prefixes[1]

nohm = (require 'nohm').Nohm

Redis = require 'redis'
redis= Redis.createClient()
redis.on 'error',(err)->
  console.log 'debug info::route-tricks::',err.message
redis.on 'connect',->
  nohm.setClient redis
  nohm.setPrefix DB_PREFIX

 
#counter
counter = 0

# the first time,express working with nohm - redis orm library

router.get  '/',(req,res,next)->
  # default index page display 10 items -- top10
  res.redirect 302,'/tricks/head10'
router.get  '/head:number',(req,res,next)->
  number = req.params.number
  #ids = await schema.sort({field:'about',direction:'DESC',limit:[0,10]}) 
  ids = await schema.find()
  total_items_length = ids.length
  ids = ids.slice -1 * number
  ids = ids.reverse()
  items = []
  if ids.length > 0
    for id in ids
      ins = await schema.load id
      items.push ins.allProperties()
    res.render 'tricks/list-items.pug',{retrieved:ids.length,total:total_items_length,items:items}
  else
    res.render 'tricks/list-items.pug',{idle:true}

router.get  '/delete/:id',(req,res,next)->
  try
    ins = await schema.load req.params.id
    ins.remove({silence:true})
    res.render 'tricks/delete',{itemid:req.params.id}
  catch error
    res.render 'tricks/delete',{itemid:req.params.id,error:error.message}

router.get  '/detail/:number',(req,res,next)->
  # item's detail page
  id = req.params.number
  try
    obj = await schema.load id
    {about,content,visits} = obj.allProperties()
    res.render 'tricks/detail-page',{id:id,about:about,visits:visits,content:content} 
  catch error
    res.render 'tricks/detail-page',{id:id,error:error.message}
    
router.get '/add',(req,res,next)->
  res.render 'tricks/add.pug',{order:counter++}

router.get '/gethappy',(req,res,next)->
  res.json {'received':req.query.id}

router.post '/add',(req,res,next)->
  if req.body.sign is '1'
    response = await handleSingleSave req.body
    return res.json response 
  else
    response = await handleArraySave parseInt(req.body.sign),req.body
    return res.json response

router.post '/onemore',(req,res,next)->
  #note that,"pug.renderFile" retrieves .pug path,not same as "res.render"
  # res.render works from root directory - "<project>/views"
  res.send pug.renderFile 'views/tricks/snippet-form.pug',{order:counter++}

router.post '/:id',(req,res,next)->
  # page index will ajax to this route,response via 'json'
  id = req.params.id
  redis = Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-tricks::',err.message
  redis.on 'connect',->
    nohm.setClient redis
    nohm.setPrefix DB_PREFIX
    trick = await schema.load id
    res.json trick.allProperties()

###
help methods
###

handleSingleSave = (body)->
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
    return Promise.resolve 
      status:'error'
      title:'failure due to database suit'
      errors: trick.errors 
  else
    trick.save().then ->
      return Promise.resolve {status:'successfully',content:trick.allProperties()}

handleArraySave = (length,body)->
  allthings = [0...length].map (i)->
    handleSingleSave 
      about:body["about"][i] 
      content:body["content"][i]
      visits:body["visits"][i]
  Promise.all allthings
module.exports = router
