$ ->
  # 注册所有类型为RADIO的控件，当点击时禁用/解禁相邻的TEXT控件。
  # because 'more+' button will new a form,so need a global counter
  formCounter = 1 # in view,has 1 form already. 
  $('#container').on 'click','input[type=radio]',(e)->
    $input_entry = $(this).closest('.form-group').next().find 'input'
    $input_exit = $input_entry.parentsUntil('form.form-horizontal').next().find 'input'
    switch $(@).val()
      when 'option1' 
        $input_entry.removeAttr 'disabled'
        $input_exit.attr 'disabled',1
      when 'option2' 
        $input_entry.attr 'disabled',1
        $input_exit.removeAttr 'disabled'
      when 'option3' 
        $input_exit.removeAttr 'disabled'
        $input_entry.removeAttr 'disabled'

  $('#container').on 'click','button.more',(e)->
    # clone default form#form0
    lastform = $('form').last()
    newer = $('#hidden-form').clone()
    newer.removeClass 'hidden'
    newer.attr 'id','form' + formCounter++
    newer.find('.btn-danger').removeAttr('disabled')
    lastform.after newer 
    e.preventDefault()
    e.stopPropagation()
    
  $('#container').on 'click','button.btn-danger',(e)->
    theform = $(@).closest('form')
    theform.remove()
    e.preventDefault()
    e.stopPropagation()

  $('#total-submit').on 'click',(e)->
     arr = $('form:not(".hidden")').serializeArray()
     for i in arr
       $('h1').first().after '<p>' +  i.name + ':' +  i.value + '</p>'
     e.preventDefault()
     e.stopPropagation()
