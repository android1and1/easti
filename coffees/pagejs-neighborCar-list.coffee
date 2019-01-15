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

  $('button.edit').on 'click',(e)->
    opts = 
      name:'<input type="text" name="name" id="name" placeholder="see.." >'
      age:'<input type="number" default="40" defaultValue="40" >'
    $parent = $(@).parents('.panel-body')
    window.neighborCarTabs $parent,'myTabs',opts

  $('#search-form').on 'submit',(evt)->
    way = $('[name=keyword-for]:checked').val()
    if way is undefined or way is null
      $(@).attr 'action','/neighborCar/find-by/license_plate_number'
    else
      $(@).attr 'action','/neighborCar/find-by/' + way 
      
    # let html form do its default submmitting.so disabled below 2 lines. 
    # evt.preventDefault()
    # evt.stopPropagation()
