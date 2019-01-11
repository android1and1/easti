###
  view - views/neighborCar/register-car.pug
  route - routes/neighborCar.js
  module - modules/md-neighborCar.js
###
$ ->
  $('#register_form').on 'submit',(evt)->
    evt.preventDefault()
    evt.stopPropagation()
    #alert $(@).serialize()
    $.ajax 
      url:'/neighborCar/register-car'
      method:'POST'
      data: $(@).serialize()
      dataType:'text'
    .done (responseText)->
      $parent = $ '#msgbox'
      createAlertBox $parent,responseText
      
      
  $('#reset').on 'click',(evt)->
    $('#register_form').trigger 'reset'
