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
# enable the variable - "req.body".like the old middware - "bodyParser"
app.use express.urlencoded({extended:false})

routers = ['neighborCar','readingjournals','tools','alpha','uploading','glossary']
routers.forEach (name)->
  path = './routes/route-' + name
  (require path)(app)('/' + name)

app.get '/',(req,res)->
  res.render 'index'
    ,
    title:'I see You'
    name:'wang!'

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
