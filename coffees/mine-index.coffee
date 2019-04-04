$ ->
  # 2019-3-3,at Petit Paris.
  # change the mind at 2019-3-4.yao qu da zhen.
  ['#user-logout','#admin-logout'].forEach (ele)->
    $(ele).on 'click',(e)->
      url = ele.replace /#/,'/'
        .replace /\-/,'/'
      $.ajax 
        url:url
        # in fact ,there is an error,not 'method',should be 'type'
        method:'PUT'
        # in fact ,there is an error,not 'responseType',should be 'dataType'
        responseType:'json'
      .done (json)->
        #in fact,there is an error,when client's role not as it said(logout),ajax will not fail,but case the 'else' case 
        if json.code is 0 
          alert json.status
          $(ele).parent().addClass 'disabled'
        else
          alert json.status + ' reason: ' + json.reason
      .fail (xhr,status,thrown)->
        console.log status 
        console.log thrown
      e.preventDefault()
      e.stopPropagation()
