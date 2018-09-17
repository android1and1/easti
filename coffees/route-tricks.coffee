fs = require 'fs'
path = require 'path'
express = require 'express'
router = express.Router()
formidable = require 'formidable'

# the first time,express working with nohm - redis orm library

router.get  '/',(req,res,next)->
  res.render 'tricks/index.pug'
module.exports = router
