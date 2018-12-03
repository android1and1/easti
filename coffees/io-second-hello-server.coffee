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
counter = 0
io = (require 'socket.io')(server)
io.engine.generateID = (req)->
  return 'custom:id:' + counter++
io.on 'connect',(socket)->
  io.of '/'
    .send  'new user,id==',socket.id 

  socket.on 'disconnect',->
    io.of '/'
      .send 'one leave.'
  socket.on 'message',(msg)->
    console.log 'socketid==',socket.id,'says:',msg
    io.of '/'
      .send socket.id + ' says -- '+msg 
