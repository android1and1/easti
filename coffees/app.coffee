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
# enable the variable - "req.body".like old express version's middware - "bodyParser"
app.use express.urlencoded({extended:false})

routers = ['tools','alpha','uploading','glossary']
routers.forEach (name)->
  path = './routes/route-' + name
  (require path)(app)('/' + name)

app.get '/',(req,res)->
  res.render 'index'
    ,
    title:'I see You'
    name:'wang!'

if require.main is module
  # it is main's responsible to starting redis-server
  pgrep = spawn 'pgrep',['redis-server']
  pgrep.on 'close',(code1)->
    if (parseInt code1) isnt 0  #means no found
      console.log 'start redis-server.'
      if process.platform is 'linux'
        conf = './redisdb/linux.redis.conf'
        redisservice = spawn 'redis-server',[conf,'--loglevel','verbose']
        redisservice.on 'error',(err)->
          console.error 'debug info::: ' + err.message
          process.exit 1
        redisservice.stdout.on 'data',(da)->
          console.log 'spawn output:'
          console.log da.toString 'utf-8'
        redisservice.on 'close',(code)->
          #console.log 'Exit With Code:',code
          #tricks = require './routes/route-tricks.js'
          #app.use '/tricks',tricks
          #readingjournals = require './routes/route-readingjournals.js'
          #app.use '/reading-journals',readingjournals
          (require './routes/route-readingjournals')(app)('/reading-journals')
          app.use (req,res)->
            res.status 404
            res.render '404'
          app.use (err,req,res,next)->
            console.error 'occurs 500 error. [[ ' + err.stack + '  ]]'
            res.type 'text/plain'
            res.status 500
            res.send '500 - Server Error!'
          server = http.Server app
          server.listen 3003,->
            console.log 'server running at port 3003;press Ctrl-C to terminate.'

      else if process.platform is 'darwin'
        conf = './redisdb/darwin.redis.conf'
        redisservice = spawn 'redis-server',[conf,'--loglevel','verbose']
        redisservice.on 'error',(err)->
          console.error 'debug info from darwin platform::: ' + err.message
          process.exit 1
        #redisservice.stdout.on 'data',(da)->
        #  console.log 'spawn output:'
        #  console.log da.toString 'utf-8'
        process.nextTick ->
          #tricks = require './routes/route-tricks.js'
          #app.use '/tricks',tricks
          (require './routes/route-readingjournals')(app)('/reading-journals')
          #readingjournals = require './routes/route-readingjournals.js'
          #app.use '/reading-journals',readingjournals
          app.use (req,res)->
            res.status 404
            res.render '404'
          app.use (err,req,res,next)->
            console.error 'occurs 500 error. [[ ' + err.stack + '  ]]'
            res.type 'text/plain'
            res.status 500
            res.send '500 - Server Error!'
          server = http.Server app
          server.listen 3003,->
            console.log 'server running at port 3003;press Ctrl-C to terminate.'
          
      else
        console.log 'unknow platform,not support.'
        process.exit 1 
    else
      # code1=0,means found progress of redis-server,no need restart.
      console.log 'redis-server started already.'
      #tricks = require './routes/route-tricks.js'
      #app.use '/tricks',tricks
      (require './routes/route-readingjournals')(app)('/reading-journals')
      #readingjournals = require './routes/route-readingjournals.js'
      #app.use '/reading-journals',readingjournals
      app.use (req,res)->
        res.status 404
        res.render '404'
      app.use (err,req,res,next)->
        console.error 'occurs 500 error. [[ ' + err.stack + '  ]]'
        res.type 'text/plain'
        res.status 500
        res.send '500 - Server Error!'
      server = http.Server app
      server.listen 3003,->
        console.log 'server running at port 3003;press Ctrl-C to terminate.'
else
  module.exports = app 
