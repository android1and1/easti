###
  target: public/pagejs/tricks/pagejs-tricks-onemoreform.js
  work with route - /tricks/add1
###
jQuery document
.ready ->
  $ 'button#submit'
  .on 'click',(evt1)->
    $.ajax
      url:''
      dataType:'text'
      data:$('form').serialize()
      type:'POST'
    .done (text)->
      $('div.extends').append $('<p/>',{text:text})
    .fail (xhr,status,code)->
      console.log status
      console.log code 
    false

  $ 'button#onemore'
  .on 'click',(evt2)->
    $.ajax 
      url:'/tricks/onemore'
      dataType:'text'
      data:{itemno:4}
      type:'POST'
    .done (text)->
      $('div.extends').append $(text)
    .fail (xhr,status,code)->
      console.log status
      console.log code 

    false
