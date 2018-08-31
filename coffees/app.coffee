path = require 'path'
http = require 'http'
express = require 'express'
app = express()
project_root = process.env.HOME + '/easti' 
app.set 'view engine','pug'
static_root = path.join project_root,'public'
app.use express.static static_root 
# include all customise router
# 1 router:tools - api
tools = require './routes/route-tools.js'
alpha = require './routes/route-alpha.js'
app.use '/tools',tools 
app.use '/alpha',alpha 
# 2 router:vip 

app.get '/',(req,res)->
  res.render 'index'
    ,
    title:'I see You'
    name:'wang!'
app.get '/show-widget',(req,res)->
  res.render 'widgets/show-widget'
app.get '/iphone-upload',(req,res)->
  res.render 'iphone-upload'
app.use (req,res)->
  res.status 404
  res.render '404'
app.use (err,req,res,next)->
  console.error err.stack
  res.type 'text/plain'
  res.status 500
  res.send '500 - Server Error!'
if require.main is module
  server = http.Server app 
  server.listen 3003,->
    console.log 'server running at port 3003;press Ctrl-C to terminate.'
else
  module.exports = app 
