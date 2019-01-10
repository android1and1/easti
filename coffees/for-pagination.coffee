$ ->
  current = 1
  arr = [
    '' # empty so element real begin from 1.
    '<p> it is contnet 1,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>'
    '<p> it is contnet 2,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>'
    '<p> it is contnet 3,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>'
    '<p> it is contnet 4,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>'
    '<p> it is contnet 5,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content ,it is content it is content</p>'
    ]
  $('li a').on 'click',(evt)->
    role = $(@).data('role') 
    order = $(@).text() 
    if role is 'chapter'
      console.log 'current:',current,'next page order:',order
      current = parseInt order
      $('.media .media-body').text arr[current] 
    else if role is 'previous' and current is 1 
      console.log 'it already 1st chapter.'
    else if role is 'previous' and current > 1
      console.log 'current:',current,'next page order:',current - 1
      current = current - 1
      $('.media .media-body').text arr[current] 
    else if role is 'next' and current is 5
      console.log 'it already the 5th chapter(the end).'
    else if role is 'next' and current < 5
      console.log 'current:',current,'next page order:',current + 1
      current = current + 1
      $('.media .media-body').text arr[current] 
    else
      console.log 'anything to do.'
