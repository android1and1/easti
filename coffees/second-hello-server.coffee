http = require 'http'
express = require 'express'
app = express()
app.set 'view engine','pug'
if process.platform is 'darwin'
  app.use express.static '/Users/mac/easti/public'
else if process.platform is 'linux'
  app.use express.static '/home/cyrus/easti/public'
else
  console.log 'dont support platform,exit.'
  process.exit 1

app.get '/',(req,res)->
  res.render 'second-hello'
    ,
    title:'the second hello:lesson2'
server = http.Server app
server.listen 2882,->console.log 'Express\+ScoketIO Running At Port:2882'

io = (require 'socket.io')(server)
sockets = []
io.on 'connect',(socket)->
  console.log 'new user id:',socket.id,'currently logging users is',sockets.length + 1
  sockets.push socket

  socket.on 'disconnect',->
    console.log 'one leave.'
  socket.on 'message',(msg)->
    console.log 'received:',msg
    for s in sockets
      s.send msg
    
