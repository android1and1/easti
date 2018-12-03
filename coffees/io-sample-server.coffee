# io port:1118
# server(Express) port:8111
http = require 'http'
express = require 'express'
app = express()
# template
app.set 'view engine','pug'
# static files
if process.platform is 'linux'
  app.use express.static '/home/cyrus/easti/public' 
else if process.platform is 'darwin'
  app.use express.static '/Users/mac/easti/public' 
else
  console.log 'unknow platform,we have not idea about this case,exit.'
  process.exit 1
server =  http.Server app
io = (require 'socket.io') 1118
io.on 'disconnect',(socket)->
  console.log 'one leave.'

io.on 'connection',(socket)->
  socket.send 'one person connected!its socket-id is:',socket.id
  socket.emit 'news',{latest:'London Bridge is falling down.'}

  # learn how to make acknowledgements
  socket.on 'mynameis',(name,fn)->
    fn 'Hello,' + name 

  socket.on 'my other event',(data)->
    console.log data
  socket.on 'disconnect',->
    console.log 'one leave.'


app.get '/',(req,res)->
  res.render 'io-client-index.pug'
    ,
    title:'i like it - socket.io'

server.listen 8111,->console.log 'http \+  socket.io server is running..'
