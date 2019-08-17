// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    // 2019-06-27 于“水墨清华”别墅区设立 
    // retry at 2019-07-27
    // continue at 2019-08-03
    $('.deleteOne,.deleteOneWithMedia').on('click', function(evt) {
      var bool, id;
      id = $(this).data('keyname');
      bool = $(this).data('with-media');
      $.ajax({
        url: '/admin/del-one-ticket?keyname=' + id + '&with_media=' + bool,
        type: 'DELETE',
        dataType: 'text'
      }).done(function(txt) {
        // reload list page.
        return window.location.reload(true);
      }).fail(function(one, two, three) {
        return alert(three);
      });
      evt.preventDefault();
      return evt.stopPropagation();
    });
    // when form.comment-form submit event be triggers, display an overlay (modal).
    $('form.comment-form').on('submit', function(evt) {
      var $this, keyname;
      
      // do ajax-post
      evt.preventDefault();
      evt.stopPropagation();
      $this = $(this);
      keyname = $this.attr('id');
      return $.ajax({
        url: '/admin/create-new-comment',
        type: 'POST',
        dataType: 'json',
        data: {
          keyname: keyname,
          comment: $this.find('[name=comment]').val()
        }
      }).done(function(json) {
        /*
        _alert_box = (parent,content)->
          box = $('<div/>',{'class':'alert alert-warning alert-dismissible fade show'})
          box.append $('<button class="close" data-dismiss="alert"><span class="oi oi-x"></span></button>')
          box.append $('<p/>').text(content)
          parent.append box
        _alert_box $('#juru'),json.replyText
        */
        return window.location.reload(true);
      }).fail(function(one, two, three) {
        return alert('ajax way create comment occurs error,reason:' + three);
      });
    });
    // each popover(as tooltip) be actived.
    return $('button[data-toggle=popover]').popover({
      placement: 'bottom',
      animation: true
    });
  });

}).call(this);
