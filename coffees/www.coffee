http = require 'http'
IO = require 'socket.io' 
app = require '../app.js'
server  =  http.Server app
io = IO server
server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'

io.on 'connect',(socket)->
  io.send 'hello everybody.'
