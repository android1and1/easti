$ ->
  $('#page-width').text 'page  width= ' + $('body').width() + ' px.'
  $('button#switch').on 'click',(evt)->
    left = $('.left')
    right = $ '.right'
    if left.hasClass 'hidden'
      left.removeClass 'hidden'
      .animate {width:'85%'},600,()->
         right.width '10%'
    else # no .hidden
      left.animate {width:'10%'},600,->
        right.animate {width:'85%'},150,->
          left.addClass 'hidden'
