$ ->
  $box = $('#box')
  user = io('/user')
  user.on 'connect',()->
    user.emit 'wow'
    user.emit 'query qr',user.id
  user.on 'message',(msg)->
    $box.append '<p>[event:message]' + msg + '</p>'
  user.on 'admin qr ready',(msg)->
    $box.append '<p>[evetn:admin qr ready]' + msg + '</p>'

  $('button#daka').on 'click',(e)->
    user.emit 'query qr',user.id
