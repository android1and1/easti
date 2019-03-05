http = require 'http'
IO = require 'socket.io' 
app = require '../app.js'
server  =  http.Server app
io = IO server
# admin_group's client page (route) is /admin/daka
admin_group = io.of '/admin'
  .on 'connect',(socket)->
    socket.send 'Good News For Administrators.' 
admin_group.on 'png ready',->
  user_group.emit 'admin qr ready','goto url:/has/png/qrcode'

# user page(client):/user/daka
user_group = io.of '/user'
  .on 'connect',(socket)->
    socket.send 'Good News For Users.'

user_group.on 'query qr',(userid)->
  # user in client page send requery for daka
  # server emit and client side .on 'show qrcode' - /admin/daka
  admin_group.emit 'qr ready','transfer from' + userid

io.on 'connect',(socket)->
  socket.send 'hi every body.'
  socket.on 'createqrcode',(text,cb)->
    # client query a qrcode
    cb '/create-qrcode?text=' + text
  socket.on 'disconnect',->
    console.log 'one user leave.'

server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'
