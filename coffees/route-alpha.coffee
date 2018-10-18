path = require 'path'
fs = require 'fs'
express = require 'express'
router = express.Router()

# test for initial level
router.get '/alpha-1',(req,res,next)->
  res.send 'hi,i am alpha No.1'
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
