# server - coffees/io-3rd-hello-server.coffee
# view - views/3rdhello.pug
# pagejs - <this>

$ ->
  #socket = io.connect 'http://127.0.0.1:8848'
  socket = io 'http://127.0.0.1:4000'
    ,
    path:'/test'
  socket.on 'connect',->
    socket.emit 'replay','i have a dream.'
  socket.on 'message',(msg)->
    alert 'server:' + msg
