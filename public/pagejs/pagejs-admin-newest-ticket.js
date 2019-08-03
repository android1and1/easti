// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    // 2019-06-27 于“水墨清华”别墅区设立 
    // retry at 2019-07-27
    // continue at 2019-08-03
    return $('#deleteOne,#deleteOneWithMedia').on('click', function(evt) {
      var bool, id;
      id = $(this).data('keyname');
      bool = $(this).data('with-media');
      $.ajax({
        url: '/admin/del-one-ticket?keyname=' + id + '&with_media=' + bool,
        type: 'DELETE',
        dataType: 'text'
      }).done(function(txt) {
        return alert('reply=' + txt);
      }).fail(function(one, two, three) {
        return alert(three);
      });
      evt.preventDefault();
      return evt.stopPropagation();
    });
  });

}).call(this);
