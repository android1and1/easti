###
  view - views/neighborCar/register-car.pug
  route - routes/neighborCar.js
  module - modules/md-neighborCar.js
###
$ ->
  $('.form-horizontal').on 'submit',(evt)->
    evt.preventDefault()
    evt.stopPropagation()
    alert $(@).serialize()
    $.ajax 
      url:'/neighborCar/register-car'
      method:'POST'
      data: $(@).serialize()
      dataType:'text'
    .done (responseText)->
      $parent = $ '#msgbox'
      createAlertBox $parent,responseText
      
      
