path = require 'path'
fs = require 'fs'
express = require 'express'
router = express.Router()

router.get '/show-server-side-accordion-suit',(req,res,next)->
  res.render 'alpha/show-model-accordion.pug',{firstitem:{id:44,content:'you guess',about:'engaing,right?',visits:44},restitems:[
     id:23
     about:'you guess1'
     content: 'long long ago...'
     visits:44
     ,
     id:33
     about:'you guess2'
     content: 'long long ago...'
     visits:44
     ,
     id:43
     about:'you guess3'
     content: 'long long ago...'
     visits:444
   ]}
 
router.get '/show-server-side-alert-box',(req,res,next)->
  # alertStyle:"alert-danger" must be carefully.final,it always become 'alertalert-danger' (no space 
  # between 'alert' and 'alert-danger'). It is client's responsibillity for guarantee keep one space as 'alert' 's postfix.
  res.render 'shows/show-server-side-alert-box',{alertContent:"Be Carefull While You Climbing.",alertStyle:"alert-danger"}
  #res.render 'shows/show-server-side-alert-box'
router.get '/indexeddb',(req,res,next)->
  # see safari or firefox window.indexeddb attribute
  res.render 'alpha/indexeddb.pug'
router.get '/canredirect',(req,res,next)->
  res.redirect 302,'/alpha/succ'
router.get '/ajax-redirect',(req,res,next)->
  res.render 'alpha/ajax-redirect'
router.post '/ajax-redirect',(req,res,next)->
  # client page send an ajax-request to this.
  # server give a json
  # res.json {state:'ok state'} 
  # actually,the ajax-redirect is fake redirect,not via http-headers.
  if req.body.message is '1' 
    res.json {command:'redirect',state:'ok'}
  else
    res.json {state:'not good!'}
# this route coplay with client-ajax,'json' to client.
router.post '/server-side-data/:num',(req,res,next)->
  pathname = path.join((path.dirname __dirname),'share','da' + req.params.num + '.json')
  fs.readFile pathname,'utf-8',(e,da)->
    #if e then res.json JSON.stringify {state:'wrong'} else res.json da
    if e
      msg =  'can not find ' + pathname + ' .'
      next msg 
    else
      res.json da
router.get '/succ',(req,res,next)->
  res.render 'alpha/succ'

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
