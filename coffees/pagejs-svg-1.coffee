$ ->
  # 5-10
  draw = SVG 'mySVG'
    .size 1800,500 
  text = draw.text (add)->
    add.tspan('We go ')
    add.tspan('up').fill('#f09').dy(-40)
    add.tspan(', then we go down, then up again').dy(40)

  path = 'M 100 200 C 200 100 300 0 400 100 C 500 200 600 300 700 200 C 800 100 900 100 900 100'

  text.path(path).font({ size: 42.5, family: 'Verdana' }) 
  text.plot('M 300 500 C 200 100 300 0 400 100 C 500 200 600 300 700 200 C 800 100 900 100 900 100')
  text.textPath().attr('startOffset', '50%')
