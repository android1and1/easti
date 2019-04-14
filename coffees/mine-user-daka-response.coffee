$ ->
  code = $('.code').data 'code'
  socket = io '/admin'
  socket.on 'connect',->
    socket.send code
