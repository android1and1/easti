express = require 'express'
router = express.Router()
formidable = require 'formidable'


router.get  '/iphone-uploading',(req,res,next)->
  res.render 'uploading/iphone-uploading'
router.post  '/iphone-uploading',(req,res,next)->
  form = new formidable.IncomingForm
  ifred = false
  form.on 'field',(name,value)->
    if name is 'ifenc' and value is 'on'
      ifred = true
    console.log 'field name',name,':',value
  form.on 'file',(name,value)->
    console.log 'FILE name',name,':',value
  form.parse req,->
    if ifred 
      res.redirect 302,'/uploading/successfully' # 302 is default code.
    else
      res.json {'server-said':'upload success'}
router.get '/successfully',(req,res,next)->
  res.render 'uploading/successfully',{title:'iphone-uploading-success'}
module.exports = router
