$ ->
  $('form').on 'submit',(evt)->
    # start validation.
    if validated
      return true
    else
      showalertbox reason
      return false
