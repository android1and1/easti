// Generated by CoffeeScript 2.3.2
(function() {
  /*
  $ ->
   *  2019 5 13
    原生的ＪＳ代码
    dRect = document.createElementNS 'http://www.w3.org/2000/svg','rect'
    dRect.setAttribute 'x',110
    dRect.setAttribute 'y',200
    dRect.setAttribute 'width',170
    dRect.setAttribute 'height',171
    dRect.setAttribute 'fill','yellow'
    $('#you-image').append $(dRect)
   */
  $(function() {
    var $rect;
    // 使用ｊＱｕｅｒｙ并加上translate效果。
    $rect = $(document.createElementNS('http://www.w3.org/2000/svg', 'rect'));
    $rect.attr({
      transform: 'translate(0,-34) rotate(14,50,45)',
      x: 110,
      y: 200,
      width: 100,
      height: 90,
      fill: 'yellow',
      stroke: 'purple',
      'stroke-width': 4
    });
    return $('#you-image').append($rect);
  });

}).call(this);
