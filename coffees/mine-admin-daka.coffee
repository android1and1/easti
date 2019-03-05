$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  $box = $('#box')
  if io
    socket = io('/admin')
    socket.on 'message',(msg)->
      alert 'Headed From ChannelAdmin - ' + msg

    socket.on 'qr ready',(msg)->
      $box.append '<h2>qr ready event:' + msg  + '</h2>'
      socket.emit 'png ready',socket.id
