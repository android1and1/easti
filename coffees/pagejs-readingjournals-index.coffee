$ ->
  $('button.nohm-delete').on 'click',(evt)->
    alert evt.target?.tagName or 'no this attribute - target.tagName'
