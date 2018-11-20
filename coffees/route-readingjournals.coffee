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
  res.send 'i see.'

module.exports = router
