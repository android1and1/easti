$ ->
  # 2019-4-11 luky xi cheng qi xiu hao le!
  $('button[data-toggle]').on 'click',(e)->
    if $(e.target).text() is '收起'
      $(e.target).button('reset')
    else
      $(e.target).button 'cower'
