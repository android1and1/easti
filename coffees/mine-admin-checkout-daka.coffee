$ ->
  $('form').on 'submit',(e)->
    # ajax do query
    $.ajax 
      url:'/daka/one'
      data:$(@).serialize()
      type:'GET'
      dataType:'json'
    .done (json)->
      $tbody = $('.table tbody')
      $tbody.html ''
      help($tbody,json)
    e.preventDefault()
    e.stopPropagation() 

  help = (tbody,arr)->
    # arr -> [{},{},...] ,each {} -> {alias:xxx,utc_ms:xxx,....}
    # change each element to '<tr>'
    # change each attr of element to '<td>'
    for ele in arr
      $tr = $('<tr/>') 
      # order:['alias','category','timestamp','dakaer']
      $tr.append $('<td/>',{text:ele.alias})
      $tr.append $('<td/>',{text:ele.category})
      $tr.append $('<td/>',{text:(new Date(ele.utc_ms)).toLocaleString()})
      $tr.append $('<td/>',{text:ele.dakaer})
      $tr.append $('<td/>',{html:'<button class="btn btn-default detailbutton"> Detail</button>'})
      tbody.append $tr
      
