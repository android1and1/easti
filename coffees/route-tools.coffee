express = require 'express'
router = express.Router()
{spawn} = require 'child_process'

router.get '/server-now',(req,res,next)->
  res.json {'server-datetime': new Date}
router.get '/client-browser-env',(req,res,next)->
  res.json 
    'req.headers':req.headers
    'req.path':req.path
    'req.params':req.params
    'req.query':req.query
    
router.get '/flushdb',(req,res,next)->
  res.send 'i am ready to flush db.'
router.get '/savenow',(req,res,next)->
  # redis-cli is a link,live in "/usr/bin/"
  # ignores secure things,like authenticate and session,cookie
  savenow = spawn 'redis-cli',['save']
  savenow.on 'close',(code)->
    if (parseInt code) isnt 0
      res.render 'hasntsaved' 
    else
      res.render 'hassaved'
# currism
toolFactory = (whichapp)->
  (whichpath)->
    whichapp.use whichpath,router
#module.exports = router
module.exports = toolFactory
