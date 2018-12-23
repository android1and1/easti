fs = require 'fs'
pug = require 'pug'
path = require 'path'
express = require 'express'
router = express.Router()
#formidable = require 'formidable'
Redis = require 'redis'
RT = require '../modules/md-readingjournals'
# for debug target

Nohm = require 'nohm'
# client not to connect this time.
[nohm1,nohm2] = [Nohm.Nohm,Nohm.Nohm]
[nohm1,nohm2].forEach (itisnohm)->
  # now we have 2 redis clients.
  redis= Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-readingjournals::',err.message
  redis.on 'connect',->
    itisnohm.setClient redis
    # another route - /neighborCar use redis-server,so,they should in same name space:'gaikai'
    itisnohm.setPrefix 'gaikai' 

router.get '/',(req,res,next)->
  schema = nohm1.register RT
  # top10
  allids = await schema.sort {'field':'visits','direction':'DESC','limit':[0,10]} 
  allitems = await schema.loadMany allids
  alljournals = []
  for item in allitems
    alljournals.push item.allProperties()
  
  res.render 'readingjournals/index',{title:'App Title','alljournals':alljournals}
  

router.get '/search-via-id/:id',(req,res,next)->
  schema = ins.register RT
  try
    items = await schema.findAndLoad
      timestamp:1412121600000
      visits:
        min:1
        max:'+inf'
    resultArray = []
    for item in items
      resultArray.push item.id + '#' + item.property 'title'
    res.json {results: resultArray} 
  catch error
    res.json {results:''}
  
  
router.post '/delete/:id',(req,res,next)->
  schema = nohm1.register RT
  # at a list page,each item has button named 'Delete It'
  thisid = req.params.id
  try
    thisins = await schema.load thisid
    thisins.remove().then ->
      res.json {status:'delete-ok'}
  catch error
    res.json {status:'delete-error',error:error.message}

router.get '/sample-mod2form',(req,res,next)->
  opts = RT.definitions
  url = 'http://www.fellow5.cn'
  snippet =  pug.render RT.mod2form(),{opts:opts,url:url}
  res.render 'readingjournals/tianna',{snippet:snippet}
# add 
router.all '/add',(req,res,next)->
  if req.method is 'POST'
    schema = nohm2.register RT
    item = await nohm2.factory RT.modelName
    {title,author,visits,reading_history,tag,timestamp,journal} = req.body
    # TODO check if value == '',let is abey default value defined in schema.
    if visits isnt ''
      item.property 'visits',visits
    if tag isnt ''
      item.property 'tag',tag
    if timestamp isnt ''
      item.property 'timestamp',timestamp
    if reading_history isnt ''
      item.property 'reading_history',reading_history
      
    item.property
      title: title
      author: author
      journal: journal
      
    try
      await item.save silence:true
      res.json {status:'ok'}
    catch error
      if error instanceof Nohm.ValidationError
         console.log 'validation error during save().,reason is',error.errors
      else
         console.log error.message
      res.json {status:'error',reason:'no save,check abouts.'}
    
  else # this case is method : 'GET'
    opts = RT.definitions
    url = '/reading-journals/add'
    snippet =  pug.render RT.mod2form(),{opts:opts,url:url}
    res.render 'readingjournals/add.pug',{snippet:snippet}

rjFactory = (app)->
  (pathname)->
    app.use pathname,router
module.exports = rjFactory
