$ ->
  $('button').on 'click',(evt)->
    # check target ether effective or not.
    ans = $(@).attr('data-accept-text') 
    if ans isnt undefined and ans.length isnt 0
      $(@).button 'accept' 
      ((context)->
        setTimeout ->context.button('reset')
          ,
          2000
       )($(@))
