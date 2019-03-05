$ ->
  $box = $('#box')
  socket = io('/user')
  socket.on 'message',(msg)->
    $box.append '<p>[event:message]' + msg + '</p>'
  socket.on 'admin qr ready',(msg)->
    $box.append '<p>[evetn:admin qr ready]' + msg + '</p>'


  $('#daka').on 'click',(e)->
    socket.emit 'query qr',socket.id
