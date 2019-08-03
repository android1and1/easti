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
