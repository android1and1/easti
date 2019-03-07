$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  $box = $('ol#box')
  $img = $box.find 'img'
  if io
    socket = io('/admin')
    socket.on 'message',(msg)->
      $box.append $('<li/>',{text:msg}) 
    socket.on 'fetch qr',(seedobj)->
      # display a png qrcode for users 'daka'

      $img.attr 'src',seedobj.url
      $box.append $ '<li/>',{text: 'Requerst Timestamp:' + seedobj.timestamp} 
      $box.append $ '<li/>',{text: seedobj.userid + ' dakaing'}
      socket.emit 'qr fetched',socket.id
