// Generated by CoffeeScript 2.3.1
(function() {
  $(function() {
    return $('button.nohm-delete').on('click', function(evt) {
      var bodyText, deleteButton, itemid, postButton, postbuttonid, titleText;
      deleteButton = $(this);
      itemid = $(evt.target).data('itemid');
      postbuttonid = 'postButton' + itemid;
      postButton = $('<button/>', {
        'data-dismiss': 'modal',
        'class': 'btn btn-danger',
        'text': 'Delete',
        'id': postbuttonid
      });
      titleText = 'Are You Sure For Delete One Item?';
      bodyText = 'click delete button will purge data forever,if you want to cancel this execute,you can click cancel or close button on the right side.';
      createModal($('#modalBox'), {
        funcButton: postButton,
        titleText: titleText,
        bodyText: bodyText
      });
      // i remember,below .on is my first use bootstrap suit's event.
      $('#myModal').on('hidden.bs.modal', function(e) {
        return $(this).remove();
      });
      $('#myModal').modal();
      return $('#' + postbuttonid).on('click', function(evt) {
        return $.ajax({
          url: '/reading-journals/delete/' + itemid,
          type: 'POST',
          dataType: 'json'
        }).done(function(json) {
          var k, v;
          $('#log').append($('<h4/>', {
            text: 'Response of execute deleting of item id:' + itemid
          }));
          for (k in json) {
            v = json[k];
            $('#log').append($('<p/>', {
              text: k + ':' + v
            }));
          }
          $('#log').append($('<br/>'));
          //console.log messages
          return deleteButton.attr('disabled', 'disabled');
        });
      });
    });
  });

}).call(this);
