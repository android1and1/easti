express = require 'express'
router = express.Router()
formidable = require 'formidable'


router.get  '/iphone-uploading',(req,res,next)->
  res.render 'uploading/iphone-uploading'
router.post  '/iphone-uploading',(req,res,next)->
  form = new formidable.IncomingForm
  form.uploadDir = './tmp'
  form.multiples = true
  ifred = false
  form.on 'file',(name,file)->
    console.log '-------'
    console.log file.name,file.path
    console.log '-------'
  form.parse req,(err,fields,files)->
    if err
      res.render 'uploading/error.pug'
    else
      ###
      # check server side received
      upload_fields_info = '<p>fields["specof"]: ' +  fields["specof"] + '</p>' 
      upload_files_info = '' 
      for v,i in files["choicefiles"]  # it is a list
        upload_files_info += '<p>files["choicefiles"][' +  (i+1) + '] ' + v.name + '</p>'
      res.send upload_fields_info + upload_files_info
      ###
      
      res.redirect 302,'/uploading/successfully' # 302 is default code.
router.get '/successfully',(req,res,next)->
  res.render 'uploading/successfully',{title:'iphone-uploading-success'}
module.exports = router
