// Generated by CoffeeScript 2.3.1
(function() {
  $(function() {
    var arr, current;
    current = 1;
    arr = ['', '<p> it is contnet 1,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>', '<p> it is contnet 2,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>', '<p> it is contnet 3,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>', '<p> it is contnet 4,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>', '<p> it is contnet 5,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>']; // empty so element real begin from 1.
    return $('li a').on('click', function(evt) {
      var order, role;
      role = $(this).data('role');
      order = $(this).text();
      if (role === 'chapter') {
        console.log('current:', current, 'next page order:', order);
        current = parseInt(order);
        return $('.media .media-body').text(arr[current]);
      } else if (role === 'previous' && current === 1) {
        return console.log('it already 1st chapter.');
      } else if (role === 'previous' && current > 1) {
        console.log('current:', current, 'next page order:', current - 1);
        current = current - 1;
        return $('.media .media-body').text(arr[current]);
      } else if (role === 'next' && current === 5) {
        return console.log('it already the 5th chapter(the end).');
      } else if (role === 'next' && current < 5) {
        console.log('current:', current, 'next page order:', current + 1);
        current = current + 1;
        return $('.media .media-body').text(arr[current]);
      } else {
        return console.log('anything to do.');
      }
    });
  });

}).call(this);