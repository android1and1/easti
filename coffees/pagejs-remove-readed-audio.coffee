$ ->
  # 2019 10 2
  $('.card-link').on 'click',(e)->
    $this = $ @
    $.ajax {
      url:'/remove-readed-audio/'
      dataType:'json'
      type:'DELETE'
      data: {data: $this.data('owner')}
    }
    .done (json)->
      # disable widgets:<a> and <audio>
      $this.parent().parent().remove()
    .fail (one,two,three)->
      alert three
