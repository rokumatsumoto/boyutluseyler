ready = undefined

ready = ->

  $('#user_username').on 'blur', (event) ->
    username = $('#user_username')
    if (username.attr('data_username') != undefined &&
       username.attr('data_username') == $('#user_username').val())
      event.stopImmediatePropagation()
      return false
    div_username = username.parent().closest('div')
    div_feedback = div_username.find('.invalid-feedback')
    if (div_feedback != undefined && div_feedback.length == 0)
      $.ajax
        url: '/exists/' + $('#user_username').val()
        type: 'GET'
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
        success: (data, textStatus, jqXHR) ->
          if data.exists == false
            username.toggleClass('is-valid', !data.exists)
                    .toggleClass('is-invalid', data.exists)
            username[0].setCustomValidity('')
          else if data.exists == true
            username.toggleClass('is-invalid', data.exists)
                    .toggleClass('is-valid', !data.exists)
            div_username.append('<div class="invalid-feedback">' + data.message + '</div>')
            div_username.addClass('form-group-invalid')
            username[0].setCustomValidity(data.message)
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
