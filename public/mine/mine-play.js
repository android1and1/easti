// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    return $('button#switch').on('click', function(evt) {
      return $('.right').animate({
        left: '+=750',
        top: '0',
        opacity: '0.85'
      }, 300, function() {
        return $('.left').css('left', 0);
      });
    });
  });

}).call(this);
