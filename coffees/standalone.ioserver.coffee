io = (require 'socket.io') 1118
io.on 'disconnect',(socket)->
  console.log 'one leave.'

io.on 'connection',(socket)->
  io.emit 'this',{will:'be received by everyone.'}
  console.log 'got 1 person.'
  socket.emit 'news',{latest:'London Bridge is falling down.'}
  socket.on 'my other event',(data)->
    console.log data
  socket.on 'disconnect',->
    console.log 'one leave.'
