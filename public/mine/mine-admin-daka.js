// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    var $box, socket;
    // 2019-3-2(1?) Manman went to school alone,but she didn't fell lonely.
    $box = $('#box');
    if (io) {
      socket = io('/admin');
      socket.on('message', function(msg) {
        return alert('Headed From ChannelAdmin - ' + msg);
      });
      return socket.on('qr ready', function(msg) {
        $box.append('<h2>qr ready event:' + msg + '</h2>');
        return socket.emit('png ready', socket.id);
      });
    }
  });

}).call(this);
