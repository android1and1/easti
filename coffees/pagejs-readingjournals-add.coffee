$ ->
  $('form').on 'submit',(evt)->
    alert $('form').serialize()
