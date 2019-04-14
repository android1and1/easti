$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  # 说说对SIO编程中最难理解的概念SOCKET的理解。
  # server-socket,client-socket(in this case) means difference,in server side socket is 2 plugins and 1 line.socket.on is real
  # listener,whereas,the channel(namespace)'s .on definition is not work about message(object) transfer.but it can .emit() to 
  # all listeners in client.
  # client-socket,its .on and .emit act as point-to-point suit,it is a 'shuang gong' mechemst.
  $pngbox = $('#pngbox')
  $msgbox = $('#msgbox')
  $img = $pngbox.find 'img'
  if !io
    $msgbox.append '<h1> IO Server Not Connect,Detect Enviroment</h1>'
  socket = io '/admin'
 
  socket.on 'message',(msg)->
    $msgbox.append $('<li/>',{text:msg}) 
    #$msgbox.append $('<li/>',{text:'in admin,socket id=' + socket.id})

  socket.on 'fetch qr',(seedobj)->
    # display a png qrcode for users 'daka'
    socketid = seedobj.socketid.replace('#','')
    querystring = '?socketid=' + socketid
    querystring += '&&timestamp=' + seedobj.timestamp
    querystring += '&&alias=' + seedobj.alias
    querystring += '&&mode=' + seedobj.mode
    # remove alias name element,then add new one.
    #beforethings =  $pngbox.find('h4.text-center')
    #if beforethings
    #  beforethings.remove()
    beforethings = $pngbox.find '.caption h3'
    if beforethings
      beforethings.remove()
    $('.caption').append $('<h3/>',{text:'打卡人  ' + seedobj.alias,'class':'text-center'})
    mode = seedobj.mode
    if mode is 'entry'
      mode = 'Entry(进场)'
    else if mode is 'exit'
      mode = 'Exit(出场)'
    else
      mode = 'Unkonw(不清)'
    $('.caption').append $('<h3/>',{text:'状态 ' + mode,'class':'text-center'})
    $img.attr 'src',seedobj.url + querystring 
    $msgbox.append $ '<li/>',{text: 'Query String:' + querystring}
    $msgbox.append $ '<li/>',{text: seedobj.socketid + ' dakaing'}
    socket.emit 'qr fetched',socket.id
