module ConfirmationHelpers
  def resend(user)
    visit new_user_session_path
    click_link 'link-confirmaton-instructions'
    fill_in 'user_email', with: user.email
    click_button 'btn_resend_confirmation'
  end

  def not_found_message_for_email
    t('activerecord.errors.models.user.attributes.email.not_found')
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
