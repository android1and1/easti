# server(Express) port:8111
# this time,we start learn to 'NameSpace' and 'room'
http = require 'http'
express = require 'express'
app = express()
app.set 'view engine','pug'

if process.platform is 'linux'
  app.use express.static '/home/cyrus/easti/public' 
else if process.platform is 'darwin'
  app.use express.static '/Users/mac/easti/public' 
else
  console.log 'unknow platform,we have not idea about this case,exit.'
  process.exit 1

server =  http.Server app
io = (require 'socket.io') server
chat = io.of '/chat'
sockets = {}
chat.on 'connection',(socket)->
  socket.on 'user.register',(name)->
    sockets[name] = socket.id
    chat.to sockets[name]
      .emit 'user.registered','chat channel user - ' + name + ' id#' + sockets[name]

  socket.on 'private message',(nickname,msg)->
    chat.to sockets[nickname] 
      .send 'from id#' + socket.id + ' message: ' + msg  
  ###
  socket.on 'room.join',(room)->
    socket.join room
    chat.to room
      .emit 'room.joined', 'id#' + socket.id + ' has joined ' + room
  ###
  ###
  socket.join 'room-19-36-21',->
    socket.send Object.keys socket.rooms

  socket.on 'message',(data,fn)->
    fn ('got server data -- ' + data + '"i see. -- by server"')
  socket.emit 'howdoyoudo','buziness',console.log
  ###

app.get '/',(req,res)->
  res.render '4thsample.pug'
    ,
    title:'the 4th sample about socket.io'

server.listen 8111,->console.log 'http \+  socket.io server is running,at port 8111.'

