fs = require 'fs'
path = require 'path'
http = require 'http'
express = require 'express'
app = express()
project_root = process.env.HOME + '/easti' 
app.set 'view engine','pug'
static_root = path.join project_root,'public'
app.use express.static static_root 
app.get '/',(req,res)->
  res.render 'fake-for-check-env'
server = http.Server app 
server.listen 8888,->
  console.log 'server running at port 8888,exec root is ' + project_root
