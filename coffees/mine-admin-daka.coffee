$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  $box = $('#box')
  if io
    socket = io('/admin')
    socket.on 'message',(msg)->
      $box.append '<h4>Server Tell That My Id Is:' + msg + '</h4>'
      $box.append '<h4>In My Side(admin daka page),My Id:' + socket.id + '</h4>'
    socket.on 'qr ready',(msg)->
      $box.append '<h4>qr ready event:' + msg  + '</h4>'
      socket.emit 'png ready',socket.id
