http = require 'http'
IO = require 'socket.io' 
app = require '../app.js'
server  =  http.Server app
io = IO server
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
    # once one user joined,should tell admin channel this change.
    admin_group.send 'one user joined right now,sockeet number:' + socket.id
    admin_group.clients (err,admins)->
      socket.send 'Current Role Admin List:' + admins.join(',')
    socket.on 'query qr',(userid)->
      # user chanel requery qrcode. server side generate a png qrcode,
      # then inform admin channel with data ,admin page will render these.
      admin_group.clients (err,admins)->
        if admins.length is 0
          user_group.emit 'no admin' 
        else
          #admin_group.emit 'fetch qr',{url:'/create-qrcode?text=there-was-something-beautiful',userid: userid ,timestamp:new Date}
          admin_group.emit 'fetch qr',{url:'/create-qrcode',socketid:userid}

io.on 'connect',(socket)->
  socket.send 'hi every body.'
  socket.on 'createqrcode',(text,cb)->
    # client query a qrcode
    cb '/create-qrcode?text=' + text
  socket.on 'disconnect',->
    console.log 'one user leave.'

server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'
