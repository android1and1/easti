$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  # 说说对SIO编程中最难理解的概念SOCKET的理解。
  # server-socket,client-socket(in this case) means difference,in server side socket is 2 plugins and 1 line.socket.on is real
  # listener,whereas,the channel(namespace)'s .on definition is not work about message(object) transfer.but it can .emit() to 
  # all listeners in client.
  # client-socket,its .on and .emit act as point-to-point suit,it is a 'shuang gong' mechemst.
  $box = $('ol#box')
  $img = $box.find 'img'
  if io
    socket = io('/admin')
 
    socket.on 'message',(msg)->
      $box.append $('<li/>',{text:msg}) 
      $box.append $('<li/>',{text:'in admin,socket id=' + socket.id})

    socket.on 'fetch qr',(seedobj)->
      # display a png qrcode for users 'daka'
      token = seedobj.socketid.replace('#','')
      token += ':' + seedobj.timestamp 
      $img.attr 'src',seedobj.url + '?text=' + token
      $box.append $ '<li/>',{text: 'Query String:' + token}
      $box.append $ '<li/>',{text: seedobj.socketid + ' dakaing'}
      socket.emit 'qr fetched',socket.id
