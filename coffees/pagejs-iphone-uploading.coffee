$(document).ready ->
  $('form').on 'submit',(evt)->
    alert 'submit event heard.'
    return true
