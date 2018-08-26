path = require 'path'
http = require 'http'
express = require 'express'
app = express()
project_root = process.env.HOME + '/easti' 
app.set 'view engine','pug'
static_root = path.join project_root,'public'
app.use express.static static_root 
app.get '/',(req,res)->
  res.render 'index'
app.get '/show-widget',(req,res)->
  res.render 'widgets/show-widget'
app.get '/iphone-upload',(req,res)->
  res.render 'iphone-upload'
app.use (req,res)->
  res.render '404'
app.use (err,req,res,next)->
  console.error err.stack
  res.type 'text/plain'
  res.status 500
  res.send '500 - Server Error!'
server = http.Server app 
server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'
