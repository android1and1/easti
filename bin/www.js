// Generated by CoffeeScript 2.3.2
(function() {
  var IO, admin, app, http, io, server;

  http = require('http');

  IO = require('socket.io');

  app = require('../app.js');

  server = http.Server(app);

  io = IO(server);

  admin = io.of('/admin').on('connect', function(socket) {
    return socket.send('You are an administrator.');
  });

  io.on('connect', function(socket) {
    socket.send('hi guys.');
    socket.on('createqrcode', function(text, cb) {
      // client query a qrcode
      return cb('/create-qrcode?text=' + text);
    });
    socket.on('wow', function(msg) {
      console.log('heard from client:', msg);
      return socket.emit('dare', 'dare to go!');
    });
    return socket.on('disconnect', function() {
      return console.log('one user leave.');
    });
  });

  server.listen(3003, function() {
    return console.log('server running at port 3003;press Ctrl-C to terminate.');
  });

}).call(this);
