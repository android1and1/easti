$ ->
  code = $('.code').data 'code'
  socket = io('http://localhost:3003/admin')
  socket.on 'connect',->
    alert socket.id
    ###
    socket.send 'parsed response code.'
    if code is '0'
      socket.emit 'daka-result','0'
    if code is '-1'
      socket.emit 'daka-result','-1'
    null
    ###
