// Generated by CoffeeScript 2.3.1
(function() {
  // 2019-1-8
  $(function() {
    return $('#search-form').on('submit', function(evt) {
      var keyword;
      keyword = $('[name=keyword-for]:checked').val();
      alert('your choice:' + keyword);
      return $(this).attr('action', '/neighborCar/' + keyword);
    });
  });

  
// evt.preventDefault()
// evt.stopPropagation()

}).call(this);
