$ ->
  $('form').on 'submit',(e)->
    $('input[name=client_time]').val new Date
  $('#onemedia').on 'change',(e)->
    # At hubei library 2019-08-02
    file =  e.target.files[0]
    $card = $('<div/>',{text:'choiced 1 file,name:' + file.name})
    $card.append '<p> file type is:' + file.type + '</p>' 
    # clear before content,and remove hidden class.
    $('div.preview').removeClass('d-none').html('')
    $('div.preview').append $card

    ###
    $img = $('<img/>',{alt:"choiced",'class':'center-block',width:"50%",border:"2px thin yellow"})
    fileReader = new FileReader
    fileReader.onload = (e)->
      $img.attr 'src',e.target.result
      $('div.preview').html ''
      $('div.preview').append $img
    fileReader.readAsDataURL @files[0]
    ### 
