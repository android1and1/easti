http = require 'http'
express = require 'express'
app = express()

server =  http.Server app
io = (require 'socket.io') 1118
io.on 'disconnect',(socket)->
  console.log 'one leave.'

io.on 'connection',(socket)->
  socket.broadcast.emit '1 person connected!'
  socket.emit 'news',{latest:'London Bridge is falling down.'}

  # learn how to make acknowledgements
  socket.on 'mynameis',(name,fn)->
    fn 'Hello,' + name 

  socket.on 'my other event',(data)->
    console.log data
  socket.on 'disconnect',->
    console.log 'one leave.'

# template
app.set 'view engine','pug'
# static files
app.use express.static '/Users/mac/easti/public' 

app.get '/',(req,res)->
  res.render 'io-client-index.pug'
    ,
    title:'i like it - socket.io'

server.listen 8111,->console.log 'http \+  socket.io server is running..'
