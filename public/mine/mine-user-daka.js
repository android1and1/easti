// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    var $box, alias, user;
    // user alias name can get from ol#box element's data-alias attribute 
    // what is socket? 
    // in this page,'user' is a really socket,from it,and to it,message or object be transfered.
    // at server side,has 2 main roles,one is namespace(always confuze with socket),and two is socket.
    $box = $('ol#box');
    alias = $box.data('alias');
    user = io('/user');
    user.on('connect', function() {
      return $box.append($('<li/>', {
        text: 'client joined socketio,id=' + user.id
      }));
    });
    user.on('message', function(msg) {
      return $box.append($('<li/>', {
        text: '[Event:message]' + msg
      }));
    });
    user.on('qr ready', function(msg) {
      return $box.append($('<li/>', {
        text: '[Event:qr ready]' + msg
      }));
    });
    user.on('no admin', function() {
      return $box.append($('<li/>', {
        text: 'No Admin Currently,Need Active It First'
      }));
    });
    return $('button#daka').on('click', function(e) {
      // if 'daka' time is out of range of ruler,server will stop daka
      // and send a message:'not daka time.'
      return user.emit('query qr', user.id, alias);
    });
  });

}).call(this);
