# 2018-10-10
$ ->
  $ 'a#yesido'
  .on 'click',(e)->
    #alert 'yes,ido.'
    $.ajax
      url:''
      type:'POST'
      dataType:'json'
      data:{message:1,elsething:'none'}

    .done (json)->
      if json?.command and json.command is 'redirect'
        # redirect via javascript.
        #document.location.href="http://127.0.0.1:3003/alpha/indexeddb"
        document.location.href='/alpha/indexeddb'
      else
        alert json.message
    
    .error (xhr,status,code)->
      alert status
      slert code
