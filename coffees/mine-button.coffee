$ ->
  # this script show how invoke button.js(bootstrap native js component).
  # at page-code(html),defines a button like this: <button id="xxx" type="button" data-xxx-text="xxx">..</button>
  # the most important is 'data-xxx-text' which 'xxx' means anything you given.
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
