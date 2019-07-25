$('document').ready  ->
  # 由SVG注射器把页面上的IMG元素，改变为一个SVG元素，再使用JS
  # 动态生成233个SVG元素，其下每个包涵USE（XLINK：HREF）
  $display = $('div#display')
  doPrepare = ->
    # there is a svg#gaogao tag exists
    $symbols = $('svg#gaogao').find 'symbol'
    for symbol in $symbols
      id = '#' +  $(symbol).attr 'id'
      $span = $ '<span/>',{'class':'d-inline-block m-2'}
      $span.append '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" xmlns:link="http://www.w3.org/1999/xlink" width="55" height="55" viewBox="0 0 16 16"><use xlink:href="' + id + '" /></svg>' 
      $span.append '<p class="d-inline-block m-1">' + id + '</p>'
      $display.append $span 
  SVGInjector $('#gaogao')[0],{},doPrepare
