fs = require 'fs'
pug = require 'pug'
path = require 'path'
express = require 'express'
router = express.Router()
#formidable = require 'formidable'
Redis = require 'redis'
RT = require '../modules/md-readingjournals'

Nohm = require 'nohm'
[nohm1,nohm2] = [Nohm.Nohm,Nohm.Nohm]
[nohm1,nohm2].forEach (itisnohm)->
  # now we have 2 redis clients.
  redis= Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-readingjournals::',err.message
  redis.on 'connect',->
    itisnohm.setClient redis
    itisnohm.setPrefix 'seesee' 


router.get '/',(req,res,next)->
  # index page,list all items.
  schema = nohm1.register RT
  allids = await schema.sort {'field':'visits','direction':'DESC','limit':[0,11]} 
  allins = await schema.loadMany allids
  alljournals = []
  for ins in allins
    alljournals.push ins.allProperties()
  
  res.render 'readingjournals/index',{title:'i am journals','alljournals':alljournals}
  

router.post '/delete/:id',(req,res,next)->
  # at a list page,each item has button named 'Delete It'
  thisid = req.params.id
  schema = nohm1.register RT
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
    ins = await nohm2.factory RT.modelName
    {title,author,visits,reading_history,tag,timestamp,journal} = req.body
    # TODO check if value == '',let is abey default value defined in schema.
    if visits isnt ''
      ins.property 'visits',visits
    if tag isnt ''
      ins.property 'tag',tag
    if timestamp isnt ''
      ins.property 'timestamp',timestamp
    if reading_history isnt ''
      ins.property 'reading_history',reading_history
      
    ins.property
      title: title
      author: author
      journal: journal
      
    try
      await ins.save silence:true
      res.json {status:'ok'}
    catch error
      if error instanceof Nohm.ValidationError
         console.log 'validation error during save().'
      else
         console.log error.message
      res.json {status:'error',reason:'no save,check abouts.'}
    
  else # this case is method : 'GET'
    opts = RT.definitions
    url = '/reading-journals/add'
    snippet =  pug.render RT.mod2form(),{opts:opts,url:url}
    res.render 'readingjournals/add.pug',{snippet:snippet}

module.exports = router
