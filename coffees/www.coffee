http = require 'http'
IO = require 'socket.io' 
app = require '../app.js'
server  =  http.Server app
io = IO server
io.on 'connect',(socket)->
  socket.send 'hi guys.'
  socket.on 'wow',(msg)->
    console.log 'heard from client:',msg
    socket.emit 'dare','dare to go!'
  socket.on 'disconnect',->
    console.log 'one user leave.'

server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'
