# 2019-1-8/9
$ ->
  $('button.delete').on 'click',(e)->
    # how do i know the id which item should delete?
    id  = $(@).data('delete-id')
    $.ajax {
      type:'DELETE'
      url:'/neighborCar/delete/' + id
      # we expecting response type
      dataType:'json'
    }
    .done (json)->
      window.createAlertBox $('div#board'),json.result       
    .fail (reason)->
      alert reason
    .always ->
      alert 'has trigger AJAX-DELETE.'
    
  $('button.vote').on 'click',(e)-> 
    # how do i know the id which item should vote?
    id  = $(@).data('vote-id')
    $.ajax
      type:'PUT'
      url:'/neighborCar/vote/' + id
      dataType:'json'
    .done (json)->
     alert JSON.stringify json 
    .fail (reason)->
      alert reason
    .always ->
      alert 'has trigger AJAX-PUT.'
       

  $('button.edit').on 'click',(e)->
    alert 'edit button be triggered.'
  $('#search-form').on 'submit',(evt)->
    keyword = $('[name=keyword-for]:checked').val()
    alert 'your choice:' + keyword
    $(@).attr 'action','/neighborCar/' + keyword
     
    # evt.preventDefault()
    # evt.stopPropagation()
