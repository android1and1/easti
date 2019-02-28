# first of first check if 'redis-server' is running.
{spawn} = require 'child_process'
pgrep = spawn '/usr/bin/pgrep',['redis-server']
pgrep.on 'close',(code)->
  if code isnt 0
    console.log 'should run redis-server first.'
    process.exit 1

path = require 'path'
fs = require 'fs'
http = require 'http'
qr_image = require 'qr-image'
crypto = require 'crypto'

# super-user's credential
fs.stat './credentials/super-user.js',(err,stats)->
  if err 
    console.log 'Credential File Not Exists,Fix It.'
    process.exit 1

credential = require './credentials/super-user.js'
superpass = credential.password

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
    maxAge: 86400 * 1000  # one day. 
    httpOnly:true
    path:'/'  # 似乎太过宽泛，之后有机会会琢磨这个
  secret: 'youkNoW.'
  store: new Store
  resave:false
  saveUninitialized:true
  } 
  
app.get '/',(req,res)->
  auth = undefined
  if req?.session?.auth
    auth  = req.session.auth
  desc = JSON.stringify req.headers["user-agent"] 
  res.render 'index'
    ,
    title:'Welcome!'
    auth:auth
    browser_desc:desc

app.get '/user/daka',(req,res)->
  auth_obj = req.session.auth
  if auth_obj is undefined 
    res.redirect 302,'/user/login'
  else
    res.render 'user-daka',{title:'User Console',auth_obj:auth_obj} 

app.get '/user/login',(req,res)->
  res.render 'user-login',{title:'Fill User Login Form'}

app.post '/user/login',(req,res)->
  # reference line#163
  {alias,password} = req.body
  # filter these 2 strings for injecting
  namebool = filter alias
  passwordbool= filter password
  if not namebool and passwordbool
    return res.json '含有非法字符（只允许ASCII字符和数字)!'
  
  if not req.session?.auth
    # auth initialize
    req.session.auth = 
      role:'unknown'
      tries:[]
      matches:[]
      counter:0
  # first check if exists this alias name?
  bool = await matchDB accountModel,alias,password
  timestamp = new Date
  if bool 
    # till here,login data is matches.
    req.session.auth.counter++
    req.session.auth.tries.push 'counter#' + counter + ':user try to login at ' + timestamp
    req.session.auth.matches.push 'Matches counter#' + counter + ' .'  
    req.session.auth.role = 'user' 
    return res.json 'user role entablished.'
  else
    return res.json 'login failure.'
    
app.get '/admin/daka',(req,res)->
  res.render 'admin-daka',{title:'Admin Console'}
 

app.get '/create-qrcode',(req,res)->
  text = req.query.text 
  # templary solid 
  text = 'http://192.168.5.2:3003/login-response?text=' + text
  res.type 'png'
  qr_image.image(text).pipe res 

app.get '/user/login-response',(req,res)->
  text = req.query.text
  if text is 'you are beautiful.'
    status = '打卡成功'
  else
    status = '验证失败 打卡未完成'
  res.render 'login-response',{title:'login Result',status:status}

# user account initialize.
app.all '/user/fill-account',(req,res)->
  if req.method is 'GET'
    res.render 'user-account-form',{title:'User Account Form'} 
  else if req.method is 'POST'
    # prepare crypto method
    {alias,password} = req.body
    ins = await Nohm.factory 'account'
    ins.property
      alias:alias
      role:'user'
      password:hashise password
      initial_timestamp:Date.parse new Date() # milion secs,integer
    try
      await ins.save()
      res.render 'save-success',{itemid:ins.id}
    catch error
      res.render 'save-fail',{reason:ins.errors}

app.get '/admin/list-accounts',(req,res)->
  if req.session.auth.alive is false
    return res.redirect 302,'/admin/login'
  inss = await accountModel.findAndLoad()
  results = [] 
  inss.forEach (one)->
    obj = {}
    obj.alias = one.property 'alias'
    obj.code = one.property 'code'
    obj.initial_timestamp = one.property 'initial_timestamp'
    obj.password = one.property 'password'
    obj.id = one.id
    results.push obj 
    
  res.render 'list-accounts',{title:'Admin:List Accounts',accounts:results}
  
app.get '/superuser/login',(req,res)->
  res.render 'superuser-login.pug',{title:'Are You A Super?'}
app.post '/superuser/login',(req,res)->
  superkey = (require './credentials/super-user.js').password
  {password} = req.body
  if password is superkey
    res.json {staus:'super user login success.'}
  else
    res.json {staus:'super user login failurre.'}
  
app.get '/admin/login',(req,res)->
  # pagejs= /mine/mine-admin-login.js
  res.render 'admin-login',{title:'Fill Authentication Form'}

app.post '/admin/login',(req,res)->
  if req.session.auth is undefined
    req.session.auth = 
      tries:[] # the desc-string base on micro million secs.
      matches:[]
      role:'unknown'
      counter:0
  {alias,password} = req.body
  password = hashise password
  # create a instance
  try
    inss = await accountModel.findAndLoad {alias:alias} 
    ins = inss[0]
    dbpassword = ins.property 'password'
  catch error
    timestamp = new Date
    counter = req.session.auth.counter++
    req.session.auth.tries.push 'try#' + counter + ' at ' + timestamp 
    req.session.auth.matches.push '*NOT* matche try#' + counter + ' .' 
    error_reason = error.message
    return res.json {status:'db error',reason:error_reason}
  if dbpassword is password
    req.session.role = 'admin'
    timestamp = new Date
    counter = req.session.auth.counter++
    req.session.auth.tries.push 'try#' + counter + ' at ' + timestamp 
    req.session.auth.matches.push 'Matches try#' + counter + ' .' 
    res.render 'admin-login-success',{title:'test if administrator',auth_data:{alias:alias,password:dbpassword}}
  else
    timestamp = new Date
    counter = req.session.auth.counter++
    req.session.auth.tries.push 'try#' + counter + ' at ' + timestamp 
    req.session.auth.matches.push '*NOT* matche try#' + counter + ' .' 
    res.json {status:'authenticate error',reason:'user account name/password peer  not match stored.'}

app.get '/admin/register',(req,res)->
  res.render 'admin-register-user',{title:'Admin-Register-User'}

app.get '/superuser/register',(req,res)->
  if req.session?.auth?.role isnt 'superuser'
    res.redirect 302,'/superuser/login'
  else
    res.render 'superuser-register-admin',{defaultValue:'1234567',title:'Superuser-register-admin'}
app.post '/superuser/register',(req,res)->
  {adminname} = req.body
  ins = await Nohm.factory 'account' 
  ins.property
    alias:adminname
    role:'admin'
    initial_timestamp:Date.parse new Date
    password:'1234567' # default password. 
  try
    await ins.save()
    res.json 'Saved.'
  catch error
    res.json  ins.errors 
  
  
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

# hashise is a help function.
hashise = (plain)->
  hash = crypto.createHash 'sha256'
  hash.update plain
  hash.digest 'hex' 
 
# filter is a help function
filter = (be_dealt_with)->
  return not /\W/.test be_dealt_with
matchDB = (db,alias,password)->
  items = await db.findAndLoad {'alias':alias}
  if items.length is 0 # means no found.
    return false
  else
    item = items[0]
    if hashise password is item.property 'password'
      return true
    else
      return false
