// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    var socket;
    socket = io();
    socket.on('message', function(msg) {
      return $('div#messagebox').append('<u>Server Send:' + msg + '</u>');
    });
    socket.on('connect', function() {
      return $('div#messagebox').append('<p>hi,socket connected.</p>');
    });
    socket.on('dare', function(msg) {
      return alert('server said:' + msg);
    });
    return $('button#trigger').on('click', function(e) {
      socket.emit('wow', 'you are beautiful.');
      return e.stopPropagation();
    });
  });

}).call(this);
