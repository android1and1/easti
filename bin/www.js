// Generated by CoffeeScript 2.3.2
(function() {
  var IO, admin_group, app, http, io, server, usage, user_group;

  http = require('http');

  IO = require('socket.io');

  app = require('../app.js');

  server = http.Server(app);

  io = IO(server);

  // 占用率
  usage = 0; //没有打卡用户请求时，为0

  // help function ,justies if daka event during daka time.
  // admin_group's client page (route) is /admin/daka
  // admin_group.on 'xxx'定义在客户端JS文件，admin_group.send 定义在服务端
  admin_group = io.of('/admin').on('connect', function(socket) {
    // once one admin joined,should tell user channel this change.
    user_group.send('one admin joined right now,socket number:' + socket.id);
    user_group.clients(function(err, clients) {
      // report important things:1,currently how many users,2,ids of them
      return socket.send('Current Client list:' + clients.join(','));
    });
    return socket.on('qr fetched', function() {
      // 虽然在定义时并没有user_group,不影响运行时态.
      return user_group.emit('qr ready', 'Qrcode is ready,go and scan for daka.');
    });
  });

  // user page(client):/user/daka
  // user_group.send定义在服务端，user_group.on定义在客户端JS文件
  user_group = io.of('/user').on('connect', function(socket) {
    // once one user joined,should tell admin channel this change.
    // client's infomation almost from socket.request.
    admin_group.send('one user joined right now,socket-id:' + socket.id);
    admin_group.send('user-agent is:' + socket.request.headers['user-agent']);
    admin_group.clients(function(err, admins) {
      return socket.send('Current Role Admin List:' + admins.join(','));
    });
    return socket.on('query qr', function(userid, alias, mode) {
      // argument - 'mode' --- is enum within ['entry','exit']
      // 3 args(userid,alias,mode) will transfors to route '/create-qrcode?xxx'(via admin_group emit) 
      // user chanel requery qrcode. server side generate a png qrcode,
      // then inform admin channel with data ,admin page will render these.
      return admin_group.clients(function(err, admins) {
        if (admins.length === 0) {
          return user_group.emit('no admin');
        } else {
          return admin_group.emit('fetch qr', {
            alias: alias,
            mode: mode,
            url: '/create-qrcode',
            timestamp: Date.now(),
            socketid: userid
          });
        }
      });
    });
  });

  server.listen(3003, function() {
    return console.log('server running at port 3003;press Ctrl-C to terminate.');
  });

}).call(this);
