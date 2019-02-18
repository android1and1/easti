# first of first check if 'redis-server' is running.
{spawn} = require 'child_process'
pgrep = spawn '/usr/bin/pgrep',['redis-server']
pgrep.on 'close',(code)->
  if code isnt 0
    console.log 'should run redis-server first.'
    process.exit 1

path = require 'path'
http = require 'http'

express = require 'express'
app = express()
PROJECT_ROOT = process.env.HOME + '/easti' 
app.set 'view engine','pug'
#static root directory setup
static_root = path.join PROJECT_ROOT,'public'
app.use express.static static_root 
# enable the variable - "req.body".like the old middware - "bodyParser"
app.use express.urlencoded({extended:false})


app.get '/',(req,res)->
  res.render 'index'
    ,
    title:'Welcome!'

app.use (req,res)->
  res.status 404
  res.render '404'
app.use (err,req,res,next)->
  console.error 'occurs 500 error. [[ ' + err.stack + '  ]]'
  res.type 'text/plain'
  res.status 500
  res.send '500 - Server Error!'
if require.main is module
  server = http.Server app
  server.listen 3003,->
    console.log 'server running at port 3003;press Ctrl-C to terminate.'
else
  module.exports = app 
