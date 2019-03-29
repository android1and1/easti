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
formidable = require 'formidable'
crypto = require 'crypto'

# super-user's credential
fs.stat './configs/credentials/super-user.js',(err,stats)->
  if err 
    console.log 'Credential File Not Exists,Fix It.'
    process.exit 1

credential = require './configs/credentials/super-user.js'
superpass = credential.password
# ruler for daka app am:7:30 pm:18:00
ruler = require './configs/ruler-of-daka.js'

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

app.get '/create-qrcode',(req,res)->
  # the query string from user-daka js code(img.src=url+'....')
  # query string include socketid,timestamp,and alias
  text = [req.query.socketid,req.query.timestamp].join('-')
  await setAsync 'important',text
  await expireAsync 'important',60
  # templary solid ,original mode is j602 
  fulltext = 'http://192.168.5.2:3003/user/daka-response?mode=' + req.query.mode + '&&alias=' + req.query.alias + '&&check=' + text 
  res.type 'png'
  qr_image.image(fulltext).pipe res 
# maniuate new func or new mind.

app.get '/user/daka',(req,res)->
  if req.session?.auth?.role isnt 'user'
    req.session.referrer = '/user/daka'
    res.redirect 303,'/user/login'
  else
    # check which scene the user now in?
    user = req.session.auth.alias
    # ruler object 
    today = new Date 
    today.setHours ruler.am.hours
    today.setMinutes ruler.am.minutes
    today.setSeconds 0
    ids = await dakaModel.find {alias:user,utc_ms:{min:Date.parse today}}
    # mode变量值为0提示“入场”待打卡状态，1则为“出场”待打卡状态。
    res.render 'user-daka',{mode:ids.length,alias:user,title:'User DaKa Console'}

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
    
app.get '/user/login-success',(req,res)->
  res.render 'user-login-success',{title:'User Role Validation:successfully'}

app.get '/user/daka-response',(req,res)->
  session_alias = req.session?.auth?.alias
  if session_alias is undefined
    req.session.referrer = '/user/daka-response'
    return res.redirect 303,'/user/login'
  if req.query.alias isnt session_alias 
    return res.json {status:'alias inconsistent',warning:'you should requery daka and visit this page via only one browser',session:session_alias,querystring:req.query.alias}
  # user-daka upload 'text' via scan-qrcode-then-goto-url.
  text = req.query.check
  dbkeep= await getAsync 'important'
  if dbkeep isnt '' and text isnt '' and dbkeep is text
    # save this daka-item
    try
      obj = new Date
      desc = obj.toString()
      ms = Date.parse obj 
      ins = await Nohm.factory 'daily'
      ins.property
        # if client has 2 difference browser,one for socketio,and one for qrcode-parser.how the 'alias' value is fit?
        alias: req.query.alias # or req.session.auth.alias 
        utc_ms: ms
        whatistime: desc 
        browser: req.headers["user-agent"] 
        category:req.query.mode # 'entry' or 'exit' mode
      await ins.save()
      return res.render 'user-daka-response',{title:'login Result',status:'打卡成功'}
    catch error
      console.log 'error',error
      # show db errors
      return res.json ins.error
  else
    return res.render 'user-daka-response',{title:'login Result',status:'打卡失败'}
    
# route-admin start
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

app.put '/admin/logout',(req,res)->
  # check if current role is correctly
  role = req.session.auth.role
  if role is 'admin'
    req.session.auth.role = 'unknown'
    req.session.auth.alias = 'noname'
    res.json {reason:'',status:'logout success'}
  else
    res.json {reason:'no this account or role isnt admin.',status:'logout failure'}

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

app.post '/admin/enable-user',(req,res)->
  id = req.body.id
  try
    ins = await Nohm.factory 'account',id
    ins.property 'isActive',true
    await ins.save()
    res.json {code:0,message:'update user,now user in active-status.' }
  catch error
    reason = {
      thrown: error
      nohm_said:ins.errors
    }
    res.json {code:-1,reason:reason}
    
app.post '/admin/disable-user',(req,res)->
  id = req.body.id
  try
    ins = await Nohm.factory 'account',id
    ins.property 'isActive',false
    await ins.save()
    res.json {code:0,message:'update user,now user in disable-status.' }
  catch error
    reason = {
      thrown: error
      nohm_said:ins.errors
    }
    res.json {code:-1,reason:reason}
    
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

app.get '/admin/list-user-daka',(req,res)->
  alias = req.query.alias
  if ! alias 
    return res.json 'no special user,check and redo.'
  if not filter alias
    return res.json 'has invalid char(s).'
  # first,check role if is admin
  if req.session?.auth?.role isnt 'admin'
    req.session.referrer = '/admin/list-user-daka?alias=' +  alias
    return res.redirect 303,'/admin/login'
  inss = await dakaModel.findAndLoad alias:alias
  result = []
  for ins in inss
    obj = ins.allProperties()
    result.push obj 
  res.render 'admin-list-user-daka',{title:'List User DaKa Items',data:result}

app.get '/admin/list-users',(req,res)->
  if req.session?.auth?.role isnt 'admin' 
    req.session.referrer = '/admin/list-users'
    return res.redirect 303,'/admin/login'
  inss = await accountModel.findAndLoad({'role':'user'})
  results = [] 
  inss.forEach (one)->
    obj = {}
    obj.alias = one.property 'alias'
    obj.role = one.property 'role'
    obj.initial_timestamp = one.property 'initial_timestamp'
    obj.password = one.property 'password'
    obj.isActive = one.property 'isActive'
    obj.id = one.id
    results.push obj 
  res.render 'admin-list-users',{title:'Admin:List-Users',accounts:results}

app.get '/superuser/list-admins',(req,res)->
  if req.session?.auth?.role isnt 'superuser'
    req.session.referrer = '/superuser/list-admins'
    return res.redirect 303,'/superuser/login'
  inss = await accountModel.findAndLoad {'role':'admin'}  
  results = [] 
  inss.forEach (one)->
    obj = {}
    obj.alias = one.property 'alias'
    obj.role = one.property 'role'
    obj.initial_timestamp = one.property 'initial_timestamp'
    obj.password = one.property 'password'
    obj.id = one.id
    results.push obj 
  res.render 'superuser-list-admins',{title:'List-Administrators',accounts:results}

app.put '/superuser/del-admin',(req,res)->
  ins = await Nohm.factory 'account'
  # req.query.id be transimit from '/superuser/list-admins' page.  
  id = req.query.id
  ins.id = id
  try
    await ins.remove()
  catch error
    return res.json {code:-1,'reason':JSON.stringify(ins.errors)}
  return res.json {code:0,'gala':'remove #' + id + ' success.'}
   
app.all '/superuser/daka-complement',(req,res)->
  if req.session?.auth?.role isnt 'superuser'
    req.session.referrer = '/superuser/daka-complement'
    return res.redirect 303,'/superuser/login'
  if req.method is 'POST'
    # client post via xhr,so server side use 'formidable' module
    formid = new formidable.IncomingForm
    formid.parse req,(err,fields,files)->
      if err
        res.json {code:-1} 
      else
        # store
        objs = convert fields 
        responses = []
        for obj in objs #objs is an array,elements be made by one object
          response = await complement_save obj['combo'],obj      
          responses.push response
        # responses example:[{},[{},{}],{}...]
        res.json responses
  else
    res.render 'superuser-daka-complement',{title:'Super User Daka-Complement'}

app.get '/superuser/login',(req,res)->
  # referrer will received from middle ware
  res.render 'superuser-login.pug',{title:'Are You A Super?'}

app.get '/superuser/login-success',(req,res)->
  res.render 'superuser-login-success.pug',{title:'Super User Login!'}

app.post '/superuser/login',(req,res)->
  # initial sesson.auth
  initSession req
  {password,itisreferrer} = req.body
  hash = sha256 password
  if hash is superpass
    updateAuthSession req,'superuser','superuser'
    if itisreferrer
      res.redirect 303,itisreferrer
    else
      res.redirect 301,'/superuser/login-success'
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

# updateAuthSession is a help function
# this method be invoked by {user|admin|superuser}/login (post request)
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
    isActive = item.property 'isActive'
    warning = ''
    if dbpassword is '8bb0cf6eb9b17d0f7d22b456f121257dc1254e1f01665370476383ea776df414'
      warning = 'should change this simple/initial/templory password immediately.'
    match_result = (isActive) and ((hashise password) is dbpassword)  and (dbrole is role) 
    return {match_result:match_result,warning:warning}

# for authenticate super user password.
sha256 = (plain)->
  crypto.createHash 'sha256'
    .update plain
    .digest 'hex'

# help func convert,can convert formidable's fields object to an object arrary(for iterator store in redis).
convert = (fields)->
  results = []
  for i,v of fields
    matched = i.match /(\D*)(\d*)$/ 
    pre = matched[1]
    post = matched[2] 
    if (post in Object.keys(results)) is false
      results[post] = {}
    results[post][pre] = v
  results

# help function - complement_save()
# complement_save handle single object(one form in client side).
complement_save = (option,fieldobj)->
  # option always is uploaded object's field - option
  response = undefined 
  # inner help function - single_save()
  single_save = (standard)->
    ins = await Nohm.factory 'daily'
    ins.property standard 
    try
      await ins.save()
    catch error
      console.dir error
      return {'item-id':ins.id,'saved':false,reason:ins.errors}
    return {'item-id':ins.id,'saved':true}
  switch option
    when 'option1'
      standard = 
        alias:fieldobj.alias
        utc_ms:Date.parse fieldobj['first-half-']
        whatistime:fieldobj['first-half-']
        dakaer:'admin'
        category:'entry' 
      response = await single_save standard
    when 'option2'
      standard = 
        alias:fieldobj.alias
        utc_ms:Date.parse fieldobj['second-half-']
        whatistime:fieldobj['second-half-']
        dakaer:'admin'
        category:'exit' 
      response = await single_save standard
    when 'option3'
      standard1 = 
        alias:fieldobj.alias
        utc_ms:Date.parse fieldobj['first-half-']
        whatistime:fieldobj['first-half-']
        dakaer:'admin'
        category:'entry' 
      standard2 = 
        alias:fieldobj.alias
        utc_ms:Date.parse fieldobj['second-half-']
        whatistime:fieldobj['second-half-']
        dakaer:'admin'
        category:'exit' 
      # save 2 instances.
      response1 = await single_save standard1
      response2 = await single_save standard2
      response = [response1,response2]
    else
      response = {code:-1,reason:'unknow status.'}
  response

# help function - 'ensure'
ensure = (req,who)->
  req.session.auth
  
