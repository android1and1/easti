// Generated by CoffeeScript 2.3.1
(function() {
  // 2019-1-8/9
  $(function() {
    $('button.delete').on('click', function(e) {
      var $button, id;
      // how do i know the id which item should delete?
      id = $(this).data('delete-id');
      // keep @ value because async func will lost it.
      $button = $(this);
      return $.ajax({
        type: 'DELETE',
        url: '/neighborCar/delete/' + id,
        // we expecting response type
        dataType: 'json'
      }).done(function(json) {
        return $button.parents('.panel.panel-default').slideUp('slow', function() {
          return window.createAlertBox($('#billboard'), json.status);
        });
      }).fail(function(reason) {
        return alert(reason);
      });
    });
    //.always ->
    //  alert 'has trigger AJAX-DELETE.'
    $('button.edit').on('click', function(e) {
      return alert('now all attributes can be edited(remove .disable class).');
    });
    $('#search-form').on('submit', function(evt) {
      var way;
      way = $('[name=keyword-for]:checked').val();
      if (way === void 0 || way === null) {
        return $(this).attr('action', '/neighborCar/find-by/license_plate_number');
      } else {
        return $(this).attr('action', '/neighborCar/find-by/' + way);
      }
    });
    
    // let html form do its default submmitting.so disabled below 2 lines. 
    // evt.preventDefault()
    // evt.stopPropagation()
    return $('button.vote').on('click', function(e) {
      var id;
      
      // how do i know the id which item should vote?
      id = $(this).data('vote-id');
      return $.ajax({
        type: 'PUT',
        url: '/neighborCar/vote/' + id,
        dataType: 'json'
      }).done(function(json) {
        if (json.error) {
          return window.createAlertBox($('#billboard'), json.error);
        } else {
          return window.createAlertBox($('#billboard'), json.status);
        }
      }).fail(function(xhr, status, thrown) {
        alert(status);
        alert(thrown);
        return console.dir(xhr);
      });
    });
  });

}).call(this);