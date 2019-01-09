# 2019-1-8/9
$ ->
  $('button.delete').on 'click',(e)->
    # how do i know the id which item should delete?
    id  = $(@).data('delete-id')
    $.ajax {
      method:'DELETE'
      url:'/neighborCar/delete/:' + id
      # we expecting response type
      dataType:'json'
    }
    .done (json)->
      window.createAlertBox $('div#board'),json.result       
    .fail (reason)->
      alert reason
    .always ->
      alert 'has trigger ajax.'
    
  $('button.edit').on 'click',(e)->
    alert 'edit button be triggered.'
  $('#search-form').on 'submit',(evt)->
    keyword = $('[name=keyword-for]:checked').val()
    alert 'your choice:' + keyword
    $(@).attr 'action','/neighborCar/' + keyword
     
    # evt.preventDefault()
    # evt.stopPropagation()
