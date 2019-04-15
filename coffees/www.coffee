http = require 'http'
IO = require 'socket.io' 
app = require '../app.js'
server  =  http.Server app
io = IO server
# 占用率
usage = 0 #没有打卡用户请求时，为0
# help function ,justies if daka event during daka time.
# admin_group's client page (route) is /admin/daka
# admin_group.on 'xxx'定义在客户端JS文件，admin_group.send 定义在服务端
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
    socket.on 'message',(user,code)->
      if code is 0
        admin_group.send 'user - ' + user + ' daka <span class="text-success">success</span>.' 
      else if code is -1
        admin_group.send 'user - ' + user + ' daka <span class="text-danger">failure</span>.'
      else
        admin_group.send 'unknown code:' + code
    socket.on 'via form',(seedobj)->
      user_group.emit 'show form'

# user page(client):/user/daka
# user_group.send定义在服务端，user_group.on定义在客户端JS文件
user_group = io.of '/user'
  .on 'connect',(socket)->
    # once one user joined,should tell admin channel this change.
    # client's infomation almost from socket.request.
    admin_group.send 'one user joined right now,socket-id:' + socket.id
    admin_group.send 'user-agent is:' + socket.request.headers['user-agent']
    
    admin_group.clients (err,admins)->
      socket.send 'Current Role Admin List:' + admins.join(',')
    socket.on 'query qr',(userid,alias,mode)->
      # argument - 'mode' --- is enum within ['entry','exit']
      # 3 args(userid,alias,mode) will transfors to route '/create-qrcode?xxx'(via admin_group emit) 
      # user chanel requery qrcode. server side generate a png qrcode,
      # then inform admin channel with data ,admin page will render these.
      admin_group.clients (err,admins)->
        if admins.length is 0
          user_group.emit 'no admin' 
        else
          admin_group.emit 'fetch qr',{alias:alias,mode:mode,url:'/create-qrcode',timestamp:Date.now(),socketid:userid}
server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'
