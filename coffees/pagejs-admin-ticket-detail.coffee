$ ->
  $('footer button').popover()
  # copied from 'public/pagejs/pagejs-admin-newest-ticket.js 
  $('.deleteOne,.deleteOneWithMedia').on 'click',(evt)->
    id = $(@).data('keyname') 
    alert 'id is:'+id
    bool = $(@).data('with-media')
    $.ajax {
      url:'/admin/del-one-ticket?keyname=' + id + '&with_media=' + bool
      type:'DELETE'
      dataType:'text'
    }
    .done (txt)->
      # reload list page.
      window.location.reload true
    .fail (one,two,three)->
      alert three
    evt.preventDefault()
    evt.stopPropagation()
  # when form.comment-form submit event be triggers, display an overlay (modal).
  $('form.comment-form').on 'submit',(evt)-> 
    # do ajax-post
    evt.preventDefault()
    evt.stopPropagation()
    $this = $ @
    keyname = $this.attr('id')
    $.ajax {
      url:'/admin/create-new-comment'
      type:'POST'
      dataType:'json'
      data: {keyname:keyname,comment: $this.find('[name=comment]').val()}
    }
    .done (json)->
      window.location.reload true 
    .fail (one,two,three)->
      alert 'ajax way create comment occurs error,reason:' + three
  # each popover(as tooltip) be actived.
  $('button[data-toggle=popover]').popover({placement:'bottom',animation:true})
  $('form#search_form input').on 'change',(e)->
    input = $(this).val()
    if input.endsWith '\n'
      $(this).closest('form').submit()
  # add modal-form,listen on it
  $('#contribute-form').on 'submit',(e)->
    e.preventDefault()
    e.stopPropagation()
    $this = $ this
    keyname=$(this).data('keyname')
    $.ajax {
      url:'/admin/contribute'
      dataType:'json'
      type:'POST'
      data:{
        'to_address':$('[name="to-address"]').val()
        'to_port': $('[name="to-port"]').val()
        keyname: ($this.data 'keyname')
      }
      timeout:12000
    }
    .done (jsonO)->
      console.log 'Server Response:' + jsonO.status 
    .fail (xhr,status,thrown)->
      alert 'something is no good,see:' + JSON.stringify thrown 
    .always ->
      $this.closest('.modal').modal('toggle')
