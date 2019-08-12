$ ->
  # 2019-06-27 于“水墨清华”别墅区设立 
  # retry at 2019-07-27
  # continue at 2019-08-03
  $('.deleteOne,.deleteOneWithMedia').on 'click',(evt)->
    id = $(@).data('keyname') 
    bool = $(@).data('with-media')
    $.ajax {
      url:'/admin/del-one-ticket?keyname=' + id + '&with_media=' + bool
      type:'DELETE'
      dataType:'text'
    }
    .done (txt)->
      # reload list page.
      window.location.reload true
      #alert 'reply=' + txt
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
    $.ajax {
      url:'/admin/create-new-comment'
      type:'POST'
      dataType:'json'
      data: {ticket_id:2,title: $this.find('[name=title]').val(),comment: $this.find('[name=comment]').val()}
    }
    .done (json)->
      alert 'server side say:' + json.replyText
    .fail (one,two,three)->
      alert three
    .always ->
      $this.closest('div.modal').modal('toggle') 
