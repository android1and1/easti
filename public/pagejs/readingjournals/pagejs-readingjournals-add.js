// Generated by CoffeeScript 2.1.1
(function() {
  $(function() {
    return $('form').on('submit', function(evt) {
      alert('heard.');
      alert($('#bootform').serialize());
      return true;
    });
  });

}).call(this);
