# the 3rd sample of socketio
# server:<this> coffees/io-3rd-hello.coffee  view:views/3rdhello.pug pagejs:public/mine/io/mine-3rdhello.js
express = require 'express'
app = express()
app.set 'view engine','pug'
app.use express.static '/home/pi/easti/public' 
app.get '/',(req,res)->
  res.render '3rdhello'
http = require 'http'
server = http.Server app 
server.listen 8848,->
  console.log 'server runing at port 8848.'
io = (require 'socket.io') {path:'/test'}
io.attach 4000 
io.on 'connect',(socket)->
  news = 'hi,welcome user:'
  news += socket.id
  io.emit 'message',news
  socket.on 'replay',(msg)->
    socket.emit 'message',msg
