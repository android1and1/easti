# first of first check if 'redis-server' is running.
{spawn} = require 'child_process'
pgrep = spawn '/usr/bin/pgrep',['redis-server']
pgrep.on 'close',(code)->
  if code isnt 0
    console.log 'should run redis-server first.'
    process.exit 1

path = require 'path'
http = require 'http'
qr_image = require 'qr-image'

{Nohm} = require 'nohm'
Account = require './modules/md-account'
Daka = require './modules/md-daka'
dakaModel = undefined
accountModel = undefined

redis = (require 'redis').createClient()
redis.on 'error',(err)->
  console.log 'Heard that:',err
redis.on 'connect',->
  Nohm.setClient @
  Nohm.setPrefix 'DaKa' # the main api name.
  # register the 2 models.
  dakaModel = Nohm.register Daka
  accountModel = Nohm.register Account

express = require 'express'
app = express()
app.set 'view engine','pug'
static_root = path.join __dirname,'public'
app.use express.static static_root 
# enable "req.body",like the old middware - "bodyParser"
app.use express.urlencoded({extended:false})
# session
Session = require 'express-session'
Store = (require 'connect-redis') Session
app.use Session {
  cookie:
    maxAge: 1 * 1000 * 60 # 1 minute
    httpOnly:true
  secret: 'youkNoW.'
  store: new Store
  resave:false
  saveUninitialized:true
  } 
  
app.get '/',(req,res)->
  res.render 'index'
    ,
    title:'Welcome!'

app.get '/daka',(req,res)->
  res.render 'daka'
    ,
    title:'Welcome Daka!'

app.get '/create-qrcode',(req,res)->
  text = req.query.text 
  # templary solid 
  text = 'http://192.168.5.2:3003/login-success?text=' + text
  res.type 'png'
  qr_image.image(text).pipe res 

app.get '/login-success',(req,res)->
  text = req.query.text
  if text is 'you are beautiful.'
    status = '打卡成功'
  else
    status = '验证失败 打卡未完成'
  res.render 'login-success',{title:'login Result',status:status}


# user account initialize.
app.all '/fill-account',(req,res)->
  if req.method is 'GET'
    res.render 'user-account-form',{title:'User Account Form'} 
  else if req.method is 'POST'
    {name,code,password} = req.body
    ins = await Nohm.factory 'account'
    ins.property
      name:name
      code:code
      password:password
      initial_timestamp:Date.parse new Date() # milion secs,integer
    try
      await ins.save()
      res.render 'save-success',{itemid:ins.id}
    catch error
      res.render 'save-fail',{reason:ins.errors}

app.get '/admin/list-accounts',(req,res)->
  inss = await accountModel.findAndLoad()
  results = [] 
  inss.forEach (one)->
    obj = one.allProperties()
    obj.id = one.id
    results.push obj 
    
  res.render 'list-accounts',{title:'Admin:List Accounts',accounts:results}
  
app.get '/admin/login',(req,res)->
  # pagejs= /mine/mine-admin-login.js
  res.render 'admin-login',{title:'Fill Authentication Form'}

app.post '/admin/login',(req,res)->
  if req.session.auth is undefined
    console.log 'now is bare-session-authentication.' 
  {name,password} = req.body
  # create a instance
  try
    inss = await accountModel.findAndLoad {name:name} 
    ins = inss[0]
    dbpassword = ins.property 'password'
  catch error
    error_reason = error.message
    return res.json {status:'db error',reason:error_reason}
  if dbpassword is password
    res.render 'login-success',{title:'test if administrator',auth_data:{name:name,password:dbpassword}}
  else
    res.json {status:'authenticate error',reason:'user account name/password peer  not match stored.'}


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
