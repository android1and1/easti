$ ->
  user = $('h2.user').data 'user'
  code = $('h2.code').data 'code'
  socket = io '/admin'
  socket.on 'connect',->
    socket.send user,code
