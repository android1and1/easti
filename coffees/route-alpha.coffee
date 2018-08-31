path = require 'path'
fs = require 'fs'
express = require 'express'
router = express.Router()

# test for initial level
router.get '/alpha-1',(req,res,next)->
  res.send 'hi,i am alpha No.1'

router.get  '/*',(req,res,next)->
  abs = path.join((path.dirname __dirname),'views',req.path)
  extname = path.extname abs
  if not fs.existsSync abs 
    next()
  else
    if extname.toLowerCase() is '.pug'
      res.render req.path.substr(1)
    else if extname.toLowerCase() is '.html'
      res.sendFile abs
    else
      console.log extname
      res.send 'not clear mime type.' 
module.exports = router
