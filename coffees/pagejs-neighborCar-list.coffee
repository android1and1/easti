# 2019-1-8/9
$ ->
  $('button.delete').on 'click',(e)->
    # how do i know the id which item should delete?
    id  = $(@).data('delete-id')
    # keep @ value because async func will lost it.
    $button = $(@)
    $.ajax {
      type:'DELETE'
      url:'/neighborCar/delete/' + id
      # we expecting response type
      dataType:'json'
    }
    .done (json)->
      $button
      .parents('.panel.panel-default')
      .slideUp 'slow',->
        window.createAlertBox $('#billboard'),json.status
    .fail (reason)->
      alert reason
    #.always ->
    #  alert 'has trigger AJAX-DELETE.'
    
  $('button.vote').on 'click',(e)-> 
    # how do i know the id which item should vote?
    id  = $(@).data('vote-id')
    $.ajax
      type:'PUT'
      url:'/neighborCar/vote/' + id
      dataType:'json'
    .done (json)->
     #alert JSON.stringify json 
     window.createAlertBox $('#billboard'),json.status
    .fail (reason)->
      alert reason
    .always ->
      alert 'has trigger AJAX-PUT.'
       

  $('button.edit').on 'click',(e)->
    alert 'edit button be triggered.'
  $('#search-form').on 'submit',(evt)->
    keyword = $('[name=keyword-for]:checked').val()
    if keyword is ''
      $(@).attr 'action','/neighborCar/' + 'find-by-license-plate-number'
    else
      $(@).attr 'action','/neighborCar/' + keyword
    # let html form do its default submmitting.so disabled below 2 lines. 
    # evt.preventDefault()
    # evt.stopPropagation()
