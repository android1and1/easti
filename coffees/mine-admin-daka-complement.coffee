$ ->
  $('button.more').on 'click',(e)->
    alert 'Clicked More Button.'
    e.preventDefault()
    e.stopPropagation()
    
