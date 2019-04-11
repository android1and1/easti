$ ->
  $('form').on 'submit',(e)->
    $('input[name=client_time]').val new Date
  $('#onephoto').on 'change',(e)->
    $img = $('<img/>',{alt:"choiced",'class':'center-block',width:"50%",border:"2px thin yellow"})
    fileReader = new FileReader
    fileReader.onload = (e)->
      $img.attr 'src',e.target.result
      $('div.preview').html ''
      $('div.preview').append $img
    fileReader.readAsDataURL @files[0]
