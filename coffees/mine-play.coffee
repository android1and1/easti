$ ->
  $('#page-width').text 'page  width= ' + $('body').width() + ' px.'
  $('button#switch').on 'click',(evt)->
    left = $('.left')
    right = $ '.right'
    if left.hasClass 'hidden'
      left.removeClass 'hidden'
      .animate {width:'1100'},600,()->
         right.width '100'
    else # no .hidden
      left.animate {width:'100'},600,->
        right.animate {width:'1300'},150,->
          left.addClass 'hidden'
