###
  target: public/pagejs/tricks/pagejs-tricks-onemoreform.js
  work with route - ./tricks/add
  work with view - ./views/tricks/snippet-form.pug
###
jQuery document
.ready ->
  # help func
  makealertbox = (info)->
    return $('<div class="alert alert-info"><button class="close" type="button" data-dismiss="alert"><span> &times </span></button><h3>' + info + '</h3></div>')
  $ 'button#submit'
  .on 'click',(evt1)->
    # debug info
    #alert $('form').serialize()
    $.ajax
      url:''
      dataType:'text'
      data:$('form').serialize() 
      type:'POST'
    .done (jsontext)->
      $('div#deadline').append makealertbox(jsontext) 
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
      $('div#deadline').append makealertbox(text)
      
    .fail (xhr,status,code)->
      console.log status
      console.log code 
    false
