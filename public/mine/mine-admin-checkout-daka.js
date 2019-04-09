// Generated by CoffeeScript 2.3.2
(function() {
  $(function() {
    var obj2list, populate;
    $('table.table').on('click', 'button.detailbutton', function(evt) {
      var data;
      evt.preventDefault();
      evt.stopPropagation();
      data = $(evt.target).data('detail');
      createModal($('body'), {
        boxid: 'youknow',
        titleText: 'Detail Of Daka',
        bodyText: data
      });
      return $('#youknow').modal();
    });
    $('form').on('submit', function(e) {
      // ajax do query
      $.ajax({
        url: '/daka/one',
        data: $(this).serialize(),
        type: 'GET',
        dataType: 'json'
      }).done(function(json) {
        var $tbody;
        $tbody = $('.table tbody');
        $tbody.html('');
        return populate($tbody, json);
      });
      e.preventDefault();
      return e.stopPropagation();
    });
    
    // populate() is a help func.
    populate = function(tbody, arr) {
      var $tr, ele, i, len, results;
// arr -> [{},{},...] ,each {} -> {alias:xxx,utc_ms:xxx,....}
// change each element to '<tr>'
// change each attr of element to '<td>'
      results = [];
      for (i = 0, len = arr.length; i < len; i++) {
        ele = arr[i];
        $tr = $('<tr/>');
        
        // order:['alias','category','timestamp','dakaer']
        $tr.append($('<td/>', {
          text: ele.alias
        }));
        $tr.append($('<td/>', {
          text: ele.category
        }));
        $tr.append($('<td/>', {
          text: (new Date(ele.utc_ms)).toLocaleString()
        }));
        $tr.append($('<td/>', {
          text: ele.dakaer
        }));
        $tr.append($('<td/>', {
          html: '<button class="btn btn-default detailbutton" data-detail="id:browser=' + ele.id + ':' + ele.browser + '" >Details</button>'
        }));
        results.push(tbody.append($tr));
      }
      return results;
    };
    // help function - obj2list
    return obj2list = function(obj) {
      var $list;
      $list = $('<ol/>');
      $list.append($('<li/>').html('<strong>id:</strong>' + obj.id));
      $list.append($('<li/>').html('<strong>user:</strong>' + obj.alias));
      $list.append($('<li/>').html('<strong>browser:</strong>' + obj.browser));
      return $list;
    };
  });

}).call(this);
