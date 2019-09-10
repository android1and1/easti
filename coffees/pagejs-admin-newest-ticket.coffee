$ ->
  # 2019-06-27 于“水墨清华”别墅区设立 
  # retry at 2019-07-27/.../2019-08-31
  # add func -- id-details (click h4.display-4(title))
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
