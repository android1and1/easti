// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    var formCounter;
    // 注册所有类型为RADIO的控件，当点击时禁用/解禁相邻的TEXT控件。
    // because 'more+' button will new a form,so need a global counter
    formCounter = 1; // in view,has 1 form already. 
    $('#container').on('click', 'input[type=radio]', function(e) {
      var $input_entry, $input_exit;
      $input_entry = $(this).closest('.form-group').next().find('input');
      $input_exit = $input_entry.parentsUntil('form.form-horizontal').next().find('input');
      switch ($(this).val()) {
        case 'option1':
          $input_entry.removeAttr('disabled');
          return $input_exit.attr('disabled', 1);
        case 'option2':
          $input_entry.attr('disabled', 1);
          return $input_exit.removeAttr('disabled');
        case 'option3':
          $input_exit.removeAttr('disabled');
          return $input_entry.removeAttr('disabled');
      }
    });
    $('#container').on('click', 'button.more', function(e) {
      var lastform, newer;
      // clone default form#form0
      lastform = $('form').last();
      newer = $('#hidden-form').clone();
      newer.removeClass('hidden');
      newer.attr('id', 'form' + formCounter++);
      newer.find('.btn-danger').removeAttr('disabled');
      lastform.after(newer);
      e.preventDefault();
      return e.stopPropagation();
    });
    $('#container').on('click', 'button.btn-danger', function(e) {
      var theform;
      theform = $(this).closest('form');
      theform.remove();
      e.preventDefault();
      return e.stopPropagation();
    });
    return $('#total-submit').on('click', function(e) {
      var arr, i, j, len;
      arr = $('form:not(".hidden")').serializeArray();
      for (j = 0, len = arr.length; j < len; j++) {
        i = arr[j];
        $('h1').first().after('<p>' + i.name + ':' + i.value + '</p>');
      }
      e.preventDefault();
      return e.stopPropagation();
    });
  });

}).call(this);
