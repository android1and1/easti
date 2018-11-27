###
app = (require 'express')()
server = require 'http'
  .Server app

io = (require 'socket.io') server
  
server.listen 1800


app.get '/',(req,res)->
  res.send 'hello,world'


io.on 'connection',(socket)->
  socket.emit 'news',{hello:'world.'}

  socket.on 'my other event',(data)->
    console.log data
###

io = (require 'socket.io') 8888
chat = io
  .of '/chat'
  .on 'connection',(socket)->
    socket.emit 'a message',{that:'only','/chat':'will get'}

news = io.of('/news').on 'connection',(socket)->
  socket.emit 'item',{news:'item'} 
