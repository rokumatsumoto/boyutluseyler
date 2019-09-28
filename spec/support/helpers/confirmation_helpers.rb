module ConfirmationHelpers
  def resend(user)
    visit new_user_confirmation_path
    fill_in 'user_email', with: user.email
    click_button 'btn_resend_confirmation'
  end

  def already_confirmed_message_for_email
    t('activerecord.errors.models.user.attributes.email.already_confirmed')
  end

  def confirmed_message_for_email
    t('devise.confirmations.confirmed')
  end

  def invalid_message_for_confirmation_token
    t('errors.messages.invalid', attribute:
      t('activerecord.attributes.user.confirmation_token'))
  end
end
