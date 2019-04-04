$ ->
  $('#page-width').text 'page  width= ' + $('body').width() + ' px.'
  $('button#switch').on 'click',(evt)->
    left = $('.left')
    right = $ '.right'
    if left.hasClass 'hidden'
      # right animate first ,then left.
      right.animate {width:'10%'},300,->
        left.removeClass 'hidden'
          .animate {width:'85%'},700
      ###
      left.removeClass 'hidden'
      .animate {width:'85%'},600,()->
        #right.width '10%'
        # give some animation.
        right.animate {width:'10%'},400
      ###

    else # no .hidden
      left.animate {width:'0%'},600,->
        right.animate {width:'95%'},150,->
          left.addClass 'hidden'

  $('#userLogout').on 'click',(e)->
    that = this
    e.preventDefault()
    e.stopPropagation() 
    $.ajax {
        url:'/user/logout'
        type:'PUT'
        dataType:'json'
      }
    .done (json)->
      alert json.status
      # disable this link.
      theli = $(that).parent()
      theli.addClass 'disabled' 
    .fail (xhr,status,thrown)->
      console.log status
      console.log thrown
