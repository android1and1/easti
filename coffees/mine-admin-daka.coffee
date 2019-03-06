$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  $box = $('#box')
  $img = $box.find 'img'
  if io
    socket = io('/admin')
    socket.on 'message',(msg)->
      $box.append $('<h3/>',{text:msg}) 
    socket.on 'fetch qr',(seedobj)->
      # display a png qrcode for users 'daka'
      alert 'heard that fetch qr event'
      $img.attr 'src',seedobj.url
      $box.append '<h4>Requerst Timestamp:' + seedobj.timestamp + '</h4>'
      $box.append '<h4>' + seedobj.userid  +  ' dakaing!</h4>'
      socket.emit 'qr fetched',socket.id
