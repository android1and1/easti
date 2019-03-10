http = require 'http'
IO = require 'socket.io' 
app = require '../app.js'
server  =  http.Server app
io = IO server
# help function ,justies if daka event during daka time.
# 打卡时间规定，上午UTC时间为23:25-23:45 pm : 9:50-9:59&&10:00-10:10
ruler = 
  am:
    # 北京时间上午7:25-7:45
    first_half:
      hour:23 #utc23=7:00AM(cst)
      minutes:
        min:25
        max:45
    second_half:null
  pm:
    # 北京时间下午17:50 - 18:10
    first_half:
      hour:9 #utc9=17:00PM
      minutes:
        min:50
        max:59
    second_half:
      hour:10 #utc10=18:00PM
      minutes:
        min:0
        max:10
isFirstClick = (ruler)->
  # get ruler.xx
  current = new Date
  hour = current.getUTCHours()
  minute = current.getUTCMinutes()
  for _,i of ruler # i in [am,pm]
    for _,ii of i  # ii in [first_half,second_half]  
      if ii is null 
        continue
      if hour isnt ii.hour
        continue
      if minute in [ii.minutes.min..ii.minutes.max] 
        return true
  false
    
# admin_group's client page (route) is /admin/daka
admin_group = io.of '/admin'
  .on 'connect',(socket)->
    # once one admin joined,should tell user channel this change.
    user_group.send 'one admin joined right now,socket number:' + socket.id
    user_group.clients (err,clients)->
      # report important things:1,currently how many users,2,ids of them
      socket.send 'Current Client list:' + clients.join(',') 
    socket.on 'qr fetched',->
      # 虽然在定义时并没有user_group,不影响运行时态.
      user_group.emit 'qr ready','Qrcode is ready,go and scan for daka.'

# user page(client):/user/daka
user_group = io.of '/user'
  .on 'connect',(socket)->
    # 来，看这里，试试看我们的IOSOCKET与APP模块（即EXRPRESS）通讯。
    # once one user joined,should tell admin channel this change.
    # client's infomation almost from socket.request.
    admin_group.send 'one user joined right now,socket-id:' + socket.id
    admin_group.send 'user-agent is:' + socket.request.headers['user-agent']
    
    admin_group.clients (err,admins)->
      socket.send 'Current Role Admin List:' + admins.join(',')
    socket.on 'query qr',(userid,alias)->
      # user chanel requery qrcode. server side generate a png qrcode,
      # then inform admin channel with data ,admin page will render these.
      admin_group.clients (err,admins)->
        if admins.length is 0
          user_group.emit 'no admin' 
        else
          admin_group.emit 'fetch qr',{alias:alias,url:'/create-qrcode',timestamp:Date.now(),socketid:userid}

io.on 'connect',(socket)->
  socket.send 'hi every body.'
  socket.on 'createqrcode',(text,cb)->
    # client query a qrcode
    cb '/create-qrcode?text=' + text
  socket.on 'disconnect',->
    console.log 'one user leave.'

server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'
