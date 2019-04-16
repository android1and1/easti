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
    # 由于属于内部调用，不需防“外部注入”
    $msgbox.append $('<li/>',{html:msg}) 
    #$msgbox.append $('<li/>',{text:'in admin,socket id=' + socket.id})

  socket.on 'fetch qr',(seedobj)->
    # display a png qrcode for users 'daka'
    socketid = seedobj.socketid.replace('#','')
    querystring = '?socketid=' + socketid
    querystring += '&&timestamp=' + seedobj.timestamp
    querystring += '&&alias=' + seedobj.alias
    querystring += '&&mode=' + seedobj.mode
    beforethings = $pngbox.find '.caption'
    if beforethings
      beforethings.html ''
    $('.caption').append $('<h3/>',{text:'打卡人  ' + seedobj.alias,'class':'text-center'})
    mode = seedobj.mode
    if mode is 'entry'
      mode = 'Entry(进场)'
    else if mode is 'exit'
      mode = 'Exit(出场)'
    else
      mode = 'Unkonw(不清)'
    $('.caption').append $('<h3/>',{text:'状态 ' + mode,'class':'text-center'})
    # add alternative daka button(chars way)
    $('.caption').append $('<button/>',{text:'alternative daka way','class':'btn btn-default btn-lg altdaka'})
    $img.attr 'src',seedobj.url + querystring 
    $msgbox.append $ '<li/>',{text: 'Query String:' + querystring}
    $msgbox.append $ '<li/>',{text: seedobj.socketid + ' dakaing'}
    socket.emit 'qr fetched',socket.id
 
    $('#pngbox').on 'click.alt','.altdaka',(evt)->
      $caption = $(@).closest('.caption')
      #  给一张表单打卡客户。
      socket.emit 'via form'
      # 生成验证字符串，与后台进行AJAX通讯，然后，显示出验证字符串。
      target_url = '/create-check-words'
      $.ajax {url:target_url,method:'GET',dataType:'json'}
      .done (json)-> 
        $caption.append '<h2>' + json + '</h2>' 
      .fail (xhr,status,thrown)->
        $caption.append '<h2>' + status + '</h2>' 
        console.log thrown
        
      $('#pngbox').off '.alt' 
