$ ->
  $('button#switch').on 'click',(evt)->
    $('.right').animate {
        left:'+=750'
        top:'0'
        opacity:'0.85'
      }
      ,
      300
      ,
      ->$('.left').css('left',0)
