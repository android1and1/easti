// Generated by CoffeeScript 2.3.1
(function() {
  /*
    target: public/pagejs/tricks/pagejs-tricks-onemoreform.js
    work with route - /tricks/add1
  */
  jQuery(document).ready(function() {
    $('button#submit').on('click', function(evt1) {
      $.ajax({
        url: '',
        dataType: 'text',
        data: $('form').serialize(),
        type: 'POST'
      }).done(function(text) {
        return $('div.extends').append($('<p/>', {
          text: text
        }));
      }).fail(function(xhr, status, code) {
        console.log(status);
        return console.log(code);
      });
      return false;
    });
    return $('button#onemore').on('click', function(evt2) {
      $.ajax({
        url: '/tricks/onemore',
        dataType: 'text',
        data: {
          itemno: 4
        },
        type: 'POST'
      }).done(function(text) {
        return $('button#onemore').before($(text));
      }).fail(function(xhr, status, code) {
        console.log(status);
        return console.log(code);
      });
      return false;
    });
  });

}).call(this);
