###
  target: public/pagejs/tricks/pagejs-tricks-onemoreform.js
  work with route - ./tricks/add
  work with view - ./views/tricks/snippet-form.pug
###
jQuery document
.ready ->
  $ 'button#submit'
  .on 'click',(evt1)->
    # debug info
    alert $('form').serialize()
    $.ajax
      url:''
      dataType:'text'
      data:$('form').serialize() 
      type:'POST'
    .done (jsontext)->
      $('div.extends').append $('<p/>',{text:jsontext})
    .fail (xhr,status,code)->
      console.log status
      console.log code 
    false

  $ 'form'
  .on 'click','button.onemore',(evt2)->
    # sign = 1 + N 
    original = parseInt $('input#behidden').val()
    $('input#behidden').val (original + 1 )
    $.ajax 
      url:'/tricks/onemore'
      dataType:'text'
      type:'POST'
    .done (text)->
      # first, change button class from .onemore to .onemoredone
      $('button.onemore').attr 'disabled','disabled'
      $('button#submit').before($(text))
      
    .fail (xhr,status,code)->
      console.log status
      console.log code 
    false
