$ ->
  $('button#switch').on 'click',(evt)->
    $('.right').animate {
        left:850
      }
      ,
      600
      ,
      ->$('.left').removeClass('hidden')
