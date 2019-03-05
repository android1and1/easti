$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  $box = $('#box')
  if io
    socket = io('/admin')
    socket.on 'message',(msg)->
      $box.append $('<h3/>',{text:msg}) 
    socket.on 'qr ready',(msg)->
      $box.append '<h4>qr ready event:' + msg  + '</h4>'
      socket.emit 'png ready',socket.id
