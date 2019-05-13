# Notice that,"$(document).ready" or "$ ->" is not fit svg document load state.should begin with below line.
window.onload = ->
  draw = $('#you-guess')[0].getSVGDocument()
  circle = $(draw).find '#thecircle' 
  $ul = $('<ul/>',{'class':'list-group'})
  for i in ['cx=' + circle.attr('cx'),'cy=' + circle.attr('cy'),'r=' + circle.attr('r')]
    $ul.append $('<li/>',{'class':'list-group-item',text:i}) 
  $('body').append $ul
