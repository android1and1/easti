path = require 'path'
http = require 'http'
{spawn} = require 'child_process'

express = require 'express'
app = express()
PROJECT_ROOT = process.env.HOME + '/easti' 
app.set 'view engine','pug'
#static root directory setup
static_root = path.join PROJECT_ROOT,'public'
app.use express.static static_root 
#bodyParser as
app.use express.urlencoded({extended:false})
# include all customise router
tools = require './routes/route-tools.js'
alpha = require './routes/route-alpha.js'
tricks = require './routes/route-tricks.js'
uploading = require './routes/route-uploading.js'
app.use '/tools',tools 
app.use '/alpha',alpha 
app.use '/uploading',uploading
app.use '/tricks',tricks

app.get '/',(req,res)->
  res.render 'index'
    ,
    title:'I see You'
    name:'wang!'
app.get '/show-widget',(req,res)->
  res.render 'widgets/show-widget'
app.use (req,res)->
  res.status 404
  res.render '404'
app.use (err,req,res,next)->
  console.error 'occurs 500 error. [[ ' + err.stack + '  ]]'
  res.type 'text/plain'
  res.status 500
  res.send '500 - Server Error!'
if require.main is module
  # it is main's responsible to starting redis-server
  pgrep = spawn 'pgrep',['redis-server']
  pgrep.on 'close',(code1)->
    if (parseInt code1) isnt 0  #means no found
      console.log 'start redis-server.'
      redisservice = spawn 'redis-server',['./redisdb/redis.conf','--loglevel','verbose']
      redisservice.on 'error',(err)->
        console.error 'debug info::: ' + err.message
        process.exit 1
      redisservice.on 'data',(da)->
        console.log 'spawn output:'
        console.log da.toString 'utf-8'

      redisservice.on 'close',(code2)->
        console.log 'Site Stop Due To Database Service Exit(with code:%s).',code2
        process.exit 1
      process.nextTick ->
        server = http.Server app
        server.listen 3003,->
          console.log 'server running at port 3003;press Ctrl-C to terminate.'
        
    else
      # code1=0,means found progress of redis-server,no need restart.
      console.log 'redis-server started already.'
      server = http.Server app
      server.listen 3003,->
        console.log 'server running at port 3003;press Ctrl-C to terminate.'
else
  module.exports = app 
