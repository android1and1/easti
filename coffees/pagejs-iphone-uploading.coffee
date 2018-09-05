$(document).ready ->
  $('#choicefiles').on 'change',(e)->
    files = $('#choicefiles')[0].files # it is a list
    parent = $('#choicefiles').parent()
    for f in files
      #alert 'you choice file is:' + f.name + ' size:' + f.size 
      html = '<p class="help-block">' + f.name + '/size ' + f.size + '</p>'
      parent.append $ html
     
     
