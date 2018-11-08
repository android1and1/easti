$ ->
  $('input[type=button]').on 'click',(evt)->
    $('#inputText')[0].setSelectionRange 0,inputText.value.length
    document.execCommand 'copy',true
