// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    $('footer button').popover();
    // copied from 'public/pagejs/pagejs-admin-newest-ticket.js 
    $('.deleteOne,.deleteOneWithMedia').on('click', function(evt) {
      var bool, id;
      id = $(this).data('keyname');
      alert('id is:' + id);
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
        return window.location.reload(true);
      }).fail(function(one, two, three) {
        return alert('ajax way create comment occurs error,reason:' + three);
      });
    });
    // each popover(as tooltip) be actived.
    $('button[data-toggle=popover]').popover({
      placement: 'bottom',
      animation: true
    });
    return $('form#search_form input').on('change', function(e) {
      var input;
      input = $(this).val();
      if (input.endsWith('\n')) {
        return $(this).closest('form').submit();
      }
    });
  });

}).call(this);
