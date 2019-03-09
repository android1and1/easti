$ ->
  # 2019-3-3,at Petit Paris.
  # change the mind at 2019-3-4.yao qu da zhen.
  ['#user-logout','#admin-logout'].forEach (ele)->
    $(ele).on 'click',(e)->
      url = ele.replace /#/,'/'
        .replace /\-/,'/'
      $.ajax 
        url:url
        method:'PUT'
        responseType:'json'
      .done (json)->
        alert json.status 
        $(ele).parent().addClass('disabled')
      .fail (one,two,three)->
        console.log two
        console.log three
      e.preventDefault()
      e.stopPropagation()
