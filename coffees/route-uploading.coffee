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
###
  below route is for learning formidable's callback's struct.
###
router.use '/learn-formidable',(req,res,next)->
  # client page is the same route,method is get,server response if client request via post.
  if req.method is 'GET'
    res.render 'uploading/learn-formidable-client.pug'
  else if req.method is 'POST'
    # initial Form
    form = new formidable.IncomingForm

    # important:upload dir,if want handle file-uploading.
    uploadDir = __dirname # absolute path,it is '<project-root>/routes/'
    uploadDir = path.dirname __dirname # shift it to '<project-root>/' 
    uploadDir = path.join uploadDir,'public','uploads' # means <project-root>/public/uploads 
    form.uploadDir =  uploadDir
    # above 4 lines can combound to 1:  form.uploadDir = (path.dirname __dirname) + '/public/uploads'

    form.type = 'urlencoded' # depending on client request.,waste this way.
    form.maxFieldsSize = 1024 * 1024 # default is 2M.
    form.maxFields = 10 # default is 1000.
    # need a collection(container)
    info = {}
    form.on 'file',(name,value)->
      # yong lai ce shi,ye shi ji hao de.2018-9-6
      # info['filefield_' + name] = value.name + '/' + value.path

      # now do:fs.rename
      oldone = value.path
      newone = oldone.slice 0,(oldone.lastIndexOf '/') + 1  # keep the '/' as suffix
      newone += value.name
      fs.renameSync oldone,newone
      
       
    form.on 'field',(name,value)->
      # dont writes as info.name = value(my first time)
      # info.name will saved the "value" in {name:"value"},so:
      # only the latest field saved.

      info[name] = value
 
    form.on 'end',(err)->
      if err
        throw new Error 'occurs parsering error.'
      else
        res.render 'uploading/learn-formidable-server.pug'
        ,
        'info':info
    form.parse req 
  else
    res.send 'we dont handle request excepts "POST" and "GET".'
     
uploadingFactory = (app)->
  (pathname)->
    app.use pathname,router
#module.exports = router
module.exports = uploadingFactory 
