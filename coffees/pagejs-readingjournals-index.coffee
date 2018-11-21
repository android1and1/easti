$ ->
  $('button.nohm-delete').on 'click',(evt)->
    $.ajax 
      url:'/reading-journals/delete/' + $(@).data('nohmid')
      type:'POST'
      dataType:'json'
    .done (json)->
      alert JSON.stringify json
    .fail (xhr,status,error)->
      alert error.message
