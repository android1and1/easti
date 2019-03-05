$ ->
  # client side listen 2 events:['admin qr ready','message'],and emit
  # 1 event 'query qr'
  $box = $('#box')
  user = io('/user')
  user.on 'connect',()->
    $box.append '<p> client joined socketio,id=' + user.id + '.</p>'
  user.on 'message',(msg)->
    $box.append '<p>[Event:message]' + msg + '</p>'
  user.on 'admin qr ready',(msg)->
    $box.append '<p>[Event:admin qr ready]' + msg + '</p>'

  $('button#daka').on 'click',(e)->
    user.emit 'query qr',user.id
