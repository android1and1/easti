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
  allids = await schema.sort {field:'whatistime',direction:'DESC',limit:[0,10]} 
  allitems = []
  for i in allids
    ins = await nohm.factory 'neighborCar',i
    allitems.push ins.allProperties()
  res.render 'neighborCar/list.pug' ,{title:'Top 10 List',top10:allitems}
    
router.post '/find-by/:index',(req,res,next)->
  # final,i need the architech like this:
  # from client,give server formdata {method:'find-by-vehicle-type',keyword:'yueye'}
  index = req.params.index
  # we no need to check if index is undefined or null,because only our scripts can touch it.
  keyword = req.body.keyword
  opts = {}
  opts[index] = keyword
  info = []
  try
    items = await schema.findAndLoad opts 
    for item in items 
      info.push item.allProperties()
  catch error
    return res.json {'error':'No This Index.'}
  res.render 'neighborCar/results-list.pug',{list:info }
 
router.get '/update/:id',(req,res,next)->
  res.send 'TODO,parse posted then response status.'
  ###
  id = req.params.id
  res.json form: '<form method="POST" action=""  class="form-horizontal"><div class="form-group"><label for="seesee"> See That:</label><input class="text" name="seesee" id="seesee" /></div><button type="submit" class="btn btn-success"> Submit!</button></form>'

  ###

router.put '/vote/:id',(req,res,next)->
  id = req.params.id
  try
    item = await nohm.factory 'neighborCar',id
    num = item.property 'visits'
    num = parseInt num
    item.property 'visits',num + 1
    old = item.property 'memo'

    memo = '<address><strong>'  
    memo += new Date
    memo += '</strong><br>'
    memo += 'has vote once.'
    memo += '<br></address>'
    item.property 'memo',old + memo
    await item.save() 
    res.json {status:'visits number added once.'}
  catch error
    res.json {error:'occurs error during add visits number,reason:' + error.message}
    
router.post '/find-by-brand',(req,res,next)->
  brand = req.body.keyword
  list = []
  try
    items = await schema.findAndLoad {'brand':brand} 
    for item in items 
      item.property 'visits',''
      await item.save()
      list.push item.allProperties()
  catch error
    return res.json {'error':'No This Brand.'}
  res.render 'neighborCar/results-list',{list:list}

router.get '/register-car',(req,res,next)->
  res.render 'neighborCar/register-car.pug',{title:'Register Car(Neighbors)'}

router.get '/update/:id',(req,res,next)->
  id = req.param.id
  try 
    item = await nohm.factory 'neighborCar',id
    properties = item.allProperties()
    res.render 'neighborCar/base-item-form.pug',{title:'Update Car',properties:properties} 
     
    
router.get '/purge-db',(req,res,next)->
  res.render 'neighborCar/purge-db.pug'

router.delete '/delete/:id',(req,res,next)->
  id = req.params.id
  try
    item = await nohm.factory 'neighborCar',id
    item.remove()
    res.json status:'item -#' + item.id + ' has deleted.'
  catch error
    res.json {status:'error about deleting.the item - ' + item.id + ' has NOT deleted.'} 
  
  
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
  ins.property 'visits',1
  ins.property 
    brand:body.brand 
    license_plate_number: body.license_plate_number
    color: body.color
    vehicle_model: body.vehicle_model
    whatistime: Date.parse(new Date)
    where_seen:body.where_seen
    memo: body.memo
  try
    await ins.save()
  catch error
    console.log ins.errors
    return res.send 'save failed.'
  res.send 'saved.'
  
   
  
neighborCarFactory = (app)->
  return (pathname)->
    app.use pathname,router

module.exports = neighborCarFactory 
