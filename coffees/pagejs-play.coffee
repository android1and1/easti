jQuery('document').ready ->
  # include window.createAlertBox already.
  # so we now invokde it.
  $commitbutton = $('button#commit')
  $commitbutton.on 'click',->
    ###
    # display datas.
    for i in  $('form').serializeArray()
      createAlertBox $('#msg'),(i.name + ':' + i.value)
    ###
    $.ajax {
      url:'/play'
      type:'POST'
      data:$('form').serializeArray()
      dataType:'json'
    }
    .done (json)->
      for i of json 
        createAlertBox $('#msg'),json[i] 
      
      
