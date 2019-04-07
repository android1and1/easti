$ ->
  $('button#switch').on 'click',(evt)->
    left = $ '.left'
    right = $ '.right'
    if left.hasClass 'hidden'
      # right animate first ,then left.
      right.animate {width:'15%'},10,->
        # 给个遮罩效果
        $('#rightmodal').toggleClass 'hidden'
        left.removeClass 'hidden'
          .animate {width:'85%'},700
    else # no .hidden
      left.animate {width:'0%'},600,->
        # 去除遮罩
        $('#rightmodal').toggleClass 'hidden'
        right.animate {width:'100%'},150,->
          left.addClass 'hidden'

  $('#adminLogout').on 'click',(e)->
    that = this
    e.preventDefault()
    e.stopPropagation() 
    $.ajax {
        url:'/admin/logout'
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
