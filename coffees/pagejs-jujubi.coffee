$ ->
  current = 1
  $('.previous').on 'click',(evt)->
    # may change current's value.
    if current > 1
      current--
      $(@).attr 'href','#p' + current 
      $(@).tab 'show'
    else
      #alert 'it is already the 1st page.'
  $('.next').on 'click',(evt)->
    # total 4 pages
    if current < 4
      current++ 
      $(@).attr 'href','#p' + current
      $(@).tab 'show'
    else
      #alert 'it is already the last page.'
      $('body').append alertbox
