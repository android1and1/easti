fs = require 'fs'
pug = require 'pug'
path = require 'path'
express = require 'express'
router = express.Router()
formidable = require 'formidable'
Redis = require 'redis'
RT = require '../modules/md-readingjournals'

Nohm = require 'nohm'
[nohm,nohm2] = [Nohm.Nohm,Nohm.Nohm]
[nohm,nohm2].forEach (itisnohm)->
  # now we have 2 redis clients.
  redis= Redis.createClient()
  redis.on 'error',(err)->
    console.log 'debug info::route-readingjournals::',err.message
  redis.on 'connect',->
    itisnohm.setClient redis
    itisnohm.setPrefix 'seesee' 


router.get  '/',(req,res,next)->
  res.render 'readingjournals/index',{title:'i am journals'}

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
    ins.property
      title: req.body.title
      author: req.body.author
      visits: req.body?.vistis or 0
      reading_history: req.body.reading_history
      tag: req.body.tag
      timestamp: req.body?.timestamp or  Date.parse new Date
      journal:req.body.journal 
      
    try
      await ins.save silence:true
    catch error
      if error instanceof Nohm.ValidationError
         console.log 'validation error during save().'
      else
         console.log error.message
      res.json {status:'error',reason:'no save,check abouts.'}
    res.json {status:'ok'}
    
  else # this case is method : 'GET'
    opts = RT.definitions
    url = '/reading-journals/add'
    snippet =  pug.render RT.mod2form(),{opts:opts,url:url}
    res.render 'readingjournals/add.pug',{snippet:snippet}

module.exports = router
