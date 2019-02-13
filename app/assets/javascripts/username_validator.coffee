ready = undefined

ready = ->

  $('#user_username').on 'blur', (event) ->
    username = $('#user_username')
    div_username = username.parent().closest('div')
    div_feedback = div_username.find('.invalid-feedback')
    if (div_feedback != undefined && div_feedback.length == 0)
      $.ajax
        url: '/username_validator/' + $('#user_username').val()
        type: 'GET'
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
        success: (data, textStatus, jqXHR) ->
          if data.valid == true
            username.toggleClass('is-valid', data.valid)
                    .toggleClass('is-invalid', !data.valid)
            username[0].setCustomValidity('')
          else if data.valid == false
            username.toggleClass('is-invalid', !data.valid)
                    .toggleClass('is-valid', data.valid)
            feedback_msg = 'Kullanıcı Adı hali hazırda kullanılmakta'
            div_username.append('<div class="invalid-feedback">' + feedback_msg + '</div>')
            div_username.addClass('form-group-invalid')
            username[0].setCustomValidity(feedback_msg)
      event.stopImmediatePropagation()
      false
  false

  $('#new_user, #edit_user').submit (event) ->
    if @checkValidity() == false
      event.preventDefault()
      event.stopPropagation()
    return

$(document).ready ready
$(document).on 'turbolinks:load', ready
