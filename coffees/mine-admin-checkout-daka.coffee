$ ->
  # defines a inner help function 
  prefill = (num)->
    str = '' + num
    if str.length is 1
      return '0'+str
    return str
  format = (value)->
    date = new Date value
    year = date.getFullYear()
    month = prefill(date.getMonth()+1)  # Jan is '0' in Date API
    day = prefill(date.getDate())
    hour = prefill(date.getHours())
    minute = prefill(date.getMinutes())
    seconds = prefill(date.getSeconds())
    milliseconds = date.getMilliseconds()
    return year + '-' + month + '-' + day + 'T' + hour + ':' + minute + ':' + seconds + '.' + milliseconds + 'Z' 
  
  $('table.table').on 'click','button.detailbutton',(evt)->
     evt.preventDefault()
     evt.stopPropagation()
     alias = $(@).data('detail-alias')
     id = $(@).data('detail-id')
     category = $(@).data('detail-category')
     browser = $(@).data('detail-browser')
     utc_ms = $(@).data('detail-utc-ms')
     alert ['条目编号: ' + id,'用户: ' + alias,'类别: ' + category,'浏览器描述: ' + browser,'打卡时间（科学表示毫秒）: ' + utc_ms].join('\n')

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
      #$tr.append $('<td/>',{text:(new Date(ele.utc_ms)).toLocaleString()})
      $tr.append $('<td/>',{text:format ele.utc_ms})
      $tr.append $('<td/>',{text:ele.dakaer})
      $button = $('<button/>',{text:'Detail','class':"btn btn-default detailbutton",'data-detail-id':ele.id,'data-detail-browser':ele.browser,'data-detail-alias':ele.alias,'data-detail-utc-ms':ele.utc_ms,'data-detail-dakaer':ele.dakaer,'data-detail-category':ele.category})
      $tr.append $('<td/>').append($button)
      tbody.append $tr
  # help function - obj2list
  obj2list = (obj)->
    $list = $('<ol/>')
    $list.append $('<li/>').html('<strong>id:</strong>' + obj.id)
    $list.append $('<li/>').html('<strong>user:</strong>' + obj.alias)
    $list.append $('<li/>').html('<strong>browser:</strong>' + obj.browser)
    $list
