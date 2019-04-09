$ ->
  $('table.table').on 'click','button.detailbutton',(evt)->
     evt.preventDefault()
     evt.stopPropagation()
     data = $(evt.target).data 'detail'
     createModal $('body'),{boxid:'youknow',titleText:'Detail Of Daka',bodyText:data}
     $('#youknow').modal() 

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
      populate($tbody,json)
    e.preventDefault()
    e.stopPropagation() 

  # populate() is a help func.
  populate = (tbody,arr)->
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
      $tr.append $('<td/>',{html:'<button class="btn btn-default detailbutton" data-detail="id:browser=' + ele.id + ':' + ele.browser + '" >Details</button>'}) 
      tbody.append $tr
  # help function - obj2list
  obj2list = (obj)->
    $list = $('<ol/>')
    $list.append $('<li/>').html('<strong>id:</strong>' + obj.id)
    $list.append $('<li/>').html('<strong>user:</strong>' + obj.alias)
    $list.append $('<li/>').html('<strong>browser:</strong>' + obj.browser)
    $list
