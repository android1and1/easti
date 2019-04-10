$ ->
  $('form').on 'submit',(e)->
    $('input[name=client_time]').val new Date
