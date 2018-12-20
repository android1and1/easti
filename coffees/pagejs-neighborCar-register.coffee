###
  view - views/neighborCar/register-car.pug
  route - routes/neighborCar.js
  module - modules/md-neighborCar.js
###
$ ->
  $('.form-horizontal').on 'submit',(e)->
    alert $(@).serialize()
    true 
