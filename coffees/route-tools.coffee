express = require 'express'
router = express.Router()
{spawn} = require 'child_process'


router.get '/tool-1',(req,res,next)->
  res.send 'hi,i am tool No.1'
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

module.exports = router
