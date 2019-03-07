$ ->
  # client side listen 2 events:['admin qr ready','message'],and emit
  # 1 event 'query qr'
  $box = $('ol#box')
  user = io('/user')
  user.on 'connect',()->
    $box.append '<li/> client joined socketio,id=' + user.id + '.</o>'
  user.on 'message',(msg)->
    $box.append $ '<li/>',{text:'[Event:message]' + msg }
  user.on 'qr ready',(msg)->
    $box.append $ '<li/>',{text:'[Event:qr ready]' + msg} 
  user.on 'no admin',->
    $box.append $ '<li/>',{text:'No Admin Currently,Need Active It First'}

  $('button#daka').on 'click',(e)->
    user.emit 'query qr',user.id
