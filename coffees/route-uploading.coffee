fs = require 'fs'
path = require 'path'
express = require 'express'
router = express.Router()
formidable = require 'formidable'


router.get  '/iphone-uploading',(req,res,next)->
  res.render 'uploading/iphone-uploading'
router.post  '/iphone-uploading',(req,res,next)->
  form = new formidable.IncomingForm
  form.uploadDir = path.join (path.dirname __dirname),'tmp'
  form.multiples = true
  ifred = false
  form.on 'file',(name,file)->
    # abs is 'absolute path string'
    prefix = file.path.slice 0,(file.path.lastIndexOf '/')
    suffix = file.name
    abs = path.join prefix,suffix
    fs.rename file.path,abs,(err)-> 
      if err
        throw new Error 'rename event occurs error.' 
  form.parse req,(err)->
    if err
      res.render 'uploading/error.pug'
    else
      # 302 is default code.
      res.locals.bytesize = '10m'
      res.redirect 302,'/uploading/successfully'
router.get '/successfully',(req,res,next)->
  res.render 'uploading/successfully',{title:'iphone-uploading-success'}
module.exports = router
