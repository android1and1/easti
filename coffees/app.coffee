# first of first check if 'redis-server' is running.
{spawn} = require 'child_process'
# this for redis promisify(client.get),the way inpirit from npm-redis.
{promisify} = require 'util'
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
setAsync = promisify redis.set
  .bind redis
getAsync = promisify redis.get
  .bind redis
expireAsync = promisify redis.expire
  .bind redis

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
 
app.use (req,res,next)->
  res.locals.referrer = req.session.referrer
  delete req.session.referrer  # then,delete() really harmless
  next()

app.get '/',(req,res)->
  role = req.session?.auth?.role
  alias = req.session?.auth?.alias
  if role is 'unknown' and alias is 'noname'
    [role,alias] = ['visitor','hi']
  res.render 'index'
    ,
    title:'welcome-daka'
    role:role
    alias:alias

app.get '/user/daka',(req,res)->
  if req.session?.auth?.role isnt 'user'
    req.session.referrer = '/user/daka'
    res.redirect 303,'/user/login'
  else
    res.render 'user-daka',{title:'User DaKa Console'}

app.get '/user/login',(req,res)->
  res.render 'user-login',{title:'Fill User Login Form'}

app.post '/user/login',(req,res)->
  # reference line#163
  {itisreferrer,alias,password} = req.body
  itisreferrer = itisreferrer or '/user/login-success'
  # filter these 2 strings for anti-injecting
  isInvalidation = (! filter alias or ! filter password)
  if isInvalidation 
    return res.render 'user-login-failure',{reason: '含有非法字符（只允许ASCII字符和数字)!',title:'User-Login-Failure'}
  # auth initialize
  initSession req
  # first check if exists this alias name?
  # mobj is 'match stats object'
  mobj = await matchDB accountModel,alias,'user',password
  if mobj.match_result 
    # till here,login data is matches.
    updateAuthSession req,'user',alias
    res.redirect 303,itisreferrer
  else
    updateAuthSession req,'unknown','noname'
    return res.render 'user-login-failure',{reason: '帐户不存在或者账户/口令不匹配!',title:'User-Login-Failure'}

app.put '/user/logout',(req,res)->
  # check if current role is correctly
  role = req.session.auth.role
  if role is 'user'
    req.session.auth.role = 'unknown'
    req.session.auth.alias = 'noname'
    res.json {reason:'',status:'logout success'}
  else
    res.json {reason:'No This Account Or Role Isnt User.',status:'logout failure'}
    
  
app.put '/admin/logout',(req,res)->
  # check if current role is correctly
  role = req.session.auth.role
  if role is 'admin'
    req.session.auth.role = 'unknown'
    req.session.auth.alias = 'noname'
    res.json {reason:'',status:'logout success'}
  else
    res.json {reason:'no this account or role isnt admin.',status:'logout failure'}

app.get '/user/login-success',(req,res)->
  res.render 'user-login-success',{title:'User Role Validation:successfully'}

app.get '/create-qrcode',(req,res)->
  text = req.query.text 
  await setAsync 'important',text
  await expireAsync 'important',60
  # templary solid ,original mode is j602 
  text = 'http://192.168.5.2:3003/user/daka-response?text=' + text
  res.type 'png'
  qr_image.image(text).pipe res 

app.get '/user/daka-response',(req,res)->
  # user-daka upload 'text' via scan-qrcode-then-goto-url.
  text = req.query.text
  dbtext = await getAsync 'important'
  stats = {original:dbtext,current:text}
  if text is dbtext and text isnt '' and dbtext isnt ''
    stats.status = '打卡成功'
  else
    stats.status = '打卡失败'
  res.render 'user-daka-response',{title:'login Result',stats:stats}

app.get '/admin/daka',(req,res)->
  if req.session?.auth?.role isnt 'admin'
    req.session.referrer = '/admin/daka'
    res.redirect 303,'/admin/login'
  else
    res.render 'admin-daka',{title:'Admin Console'}
 
app.get '/admin/login',(req,res)->
  # pagejs= /mine/mine-admin-login.js
  res.render 'admin-login',{title:'Fill Authentication Form'}

app.get '/admin/admin-update-password',(req,res)->
  res.render 'admin-update-password',{title:'Admin-Update-Password'}

app.post '/admin/admin-update-password',(req,res)->
  {oldpassword,newpassword,alias} = req.body
  items = await accountModel.findAndLoad {alias:alias}
  if items.length is 0
    res.json 'no found!'
  else
    item = items[0]
    dbkeep = item.property 'password'
    if dbkeep is hashise oldpassword
      # update this item's password part
      item.property 'password',hashise newpassword
      try
        item.save()
      catch error
        return res.json item.error 
      return res.json 'Update Password For Admin.'
    else #password is mismatches.
      return res.json 'Mismatch your oldpassword,check it.'
    
app.get '/admin/register-user',(req,res)->
  if req.session?.auth?.role isnt 'admin'
    res.redirect 302,'/admin/login'
  else
    res.render 'admin-register-user',{title:'Admin-Register-User'}

app.post '/admin/register-user',(req,res)->
  {alias,password} = req.body
  if ! filter alias or ! filter password
    return res.json 'Wrong:User Name(alias) contains invalid character(s).'
  ins = await Nohm.factory 'account' 
  ins.property
    alias:alias
    role:'user'
    initial_timestamp:Date.parse new Date
    # always remember:hashise!!
    password: hashise password 
  try
    await ins.save()
    res.json 'Register User - ' + alias
  catch error
    res.json  ins.errors 

app.post '/admin/login',(req,res)->
  {itisreferrer,alias,password} = req.body
  itisreferrer = itisreferrer or '/admin/login-success' 
  # filter alias,and password
  isInvalid = ( ! filter alias or ! filter password)
  if isInvalid 
    return res.render 'admin-login-failure',{title:'Login-Failure',reason:'contains invalid char(s).'} 
  # initial session.auth
  initSession req
  # first check if exists this alias name?
  # mobj is 'match stats object'
  mobj = await matchDB accountModel,alias,'admin',password
  if mobj.match_result 
    # till here,login data is matches.
    updateAuthSession req,'admin',alias
    res.redirect 303,itisreferrer
  else
    updateAuthSession req,'unknown','noname'
    res.render 'admin-login-failure' ,{title:'Login-Failure',reason:'account/password peer dismatches.'}

  

app.get '/admin/login-success',(req,res)->
  res.render 'admin-login-success.pug',{title:'Administrator Role Entablished'}

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
  # initial sesson.auth
  initSession req
  superkey = (require './credentials/super-user.js').password
  {password} = req.body
  hash = sha256 password
  if hash is superkey
    updateAuthSession req,'superuser','superuser'
    res.json {staus:'super user login success.'}
  else
    updateAuthSession req,'unknown','noname'
    res.json {staus:'super user login failurre.'}
  

app.get '/superuser/register-admin',(req,res)->
  if req.session?.auth?.role isnt 'superuser'
    res.redirect 302,'/superuser/login'
  else
    res.render 'superuser-register-admin',{defaultValue:'1234567',title:'Superuser-register-admin'}

       
  
app.post '/superuser/register-admin',(req,res)->
  {adminname} = req.body
  if ! filter adminname
    return res.json 'Wrong:Admin Name(alias) contains invalid character(s).'
  ins = await Nohm.factory 'account' 
  ins.property
    alias:adminname
    role:'admin'
    initial_timestamp:Date.parse new Date
    password: hashise '1234567' # default password. 
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

# initSession is a help function
initSession = (req)->
  if not req.session?.auth
    req.session.auth = 
      alias:'noname'
      counter:0
      tries:[]
      matches:[]
      role:'unknown'    
  null

# hashise is a help function.
hashise = (plain)->
  hash = crypto.createHash 'sha256'
  hash.update plain
  hash.digest 'hex' 
 
# filter is a help function
filter = (be_dealt_with)->
  # return true is safe,return false means injectable.
  return not /\W/.test be_dealt_with

# matchDB is a help function 
# *Notice that* invoke this method via "await <this>"
matchDB = (db,alias,role,password)->
  # db example 'accountModel'
  items = await db.findAndLoad {'alias':alias}
  if items.length is 0 # means no found.
    return false
  else
    item = items[0]
    dbpassword =  item.property 'password'
    dbrole = item.property 'role'
    warning = ''
    if dbpassword is '8bb0cf6eb9b17d0f7d22b456f121257dc1254e1f01665370476383ea776df414'
      warning = 'should change this simple/initial/templory password immediately.'
    match_result = ((hashise password) is dbpassword  and dbrole is role) 
    return {match_result:match_result,warning:warning}

# updateAuthSession is a help function
updateAuthSession = (req,role,alias)->
  timestamp = new Date
  counter = req.session.auth.counter++
  req.session.auth.tries.push 'counter#' + counter + ':user try to login at ' + timestamp
  req.session.auth.role = role 
  req.session.auth.alias = alias 
  if role is 'unknown'
    req.session.auth.matches.push '*Not* Matches counter#' + counter + ' .'  
  else
    req.session.auth.matches.push 'Matches counter#' + counter + ' .'  
   
# for authenticate super user password.
sha256 = (plain)->
  crypto.createHash 'sha256'
    .update plain
    .digest 'hex'
