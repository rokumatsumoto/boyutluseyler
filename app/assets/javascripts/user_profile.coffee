ready = undefined

ready = ->

  $('#edit_user').submit (event) ->
    password = $('#user_password')
    password_confirmation = $('#user_password_confirmation')
    current_password = $('#user_current_password')
    div_current_password = current_password.parent().closest('div')
    div_feedback = div_current_password.find('.invalid-feedback')
    if !!password.val() && !!password_confirmation.val() &&
       !current_password.val()
      if div_feedback != undefined && div_feedback.length == 0
        current_password.toggleClass('is-invalid', true)
                        .toggleClass('is-valid', false)
        feedback_msg = 'Geçerli Parola doldurulmalı'
        div_current_password.append('<div class="invalid-feedback">' + feedback_msg + '</div>')
        div_current_password.addClass('form-group-invalid')
      event.stopImmediatePropagation()
      false

$(document).ready ready
$(document).on 'turbolinks:load', ready
