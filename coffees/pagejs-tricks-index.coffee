$ ->
  $('a').on 'click',(evt)->
    # do-ajax
    # step1 - get evt.target's url.
    url = $ @
    .attr 'href'
    $.ajax 
      url:url
      responseType:'json'
      method:'POST'
    .catch ->alert 'wrong.'
    .done (json)->
      # 这里的字符串插值方式很常见，实用！
      say = "id is #{json.id},about is #{json.about},content is #{json.content},moment is #{json.moment},visits is #{json.moment}."
      alert say 
    false
     
