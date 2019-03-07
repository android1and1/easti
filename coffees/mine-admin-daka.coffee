$ ->
  # 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
  # 说说对SIO编程中最难理解的概念SOCKET的理解。
  # 这篇中，SOCKET很专一，就是指联系ADMIN页与服务器（具体SIO）中的对偶体插座，中文插座，适配器
  # 它必然是一个导电（电流于是互通）的一线双头结构，同理我们把流量当作“一线”，服务端监听代码当“一头”
  # 而客户端监听代码当“另一头”，就能理解到服务端的信息要想“推送”到另一头，需要作用在此专用的SOCKET上
  # whereas clinet want talk to server,need its socket too.
  # but how about server's channel(in this case it is 'admin-group') call to one client(a browser)
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
      token += ':' + Date.now() 
      $img.attr 'src',seedobj.url + '?text=' + token
      $box.append $ '<li/>',{text: 'Query String:' + token}
      $box.append $ '<li/>',{text: seedobj.socketid + ' dakaing'}
      socket.emit 'qr fetched',socket.id
