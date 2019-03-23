$ ->
  # after window.loaded,create a form -- form0
  counter = 0
  (new_form(counter++)).insertBefore $('#total-submit') 
  # the first form should disable 'delete' button
  $('button.btn-danger').attr 'disabled',1 
  # 注册所有类型为RADIO的控件，当点击时禁用/解禁相邻的TEXT控件。
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
    # create a new form
    $form = new_form(counter)
    $form.insertBefore $('#total-submit') 
    e.preventDefault()
    e.stopPropagation()
    counter++

  $('#container').on 'click','button.btn-danger',(e)->
    theform = $(@).closest('form')
    theform.remove()
    e.preventDefault()
    e.stopPropagation()

  $('#total-submit').on 'click',(e)->
    arr = $('form').serializeArray()
    for i in arr
      $('h1').first().after '<p>' +  i.name + ':' +  i.value + '</p>'
    e.preventDefault()
    e.stopPropagation()
