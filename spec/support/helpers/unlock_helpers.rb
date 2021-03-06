module UnlockHelpers
  def resend(user)
    visit new_user_unlock_path
    fill_in 'user_email', with: user.email
    click_button 'btn_resend_unlock'
  end

  def not_locked_message_for_account
    t('activerecord.errors.models.user.attributes.email.not_locked')
  end

  def unlocked_message_for_account
    t('devise.unlocks.unlocked')
  end

  def invalid_message_for_unlock_token
    t('errors.messages.invalid', attribute:
      t('activerecord.attributes.user.unlock_token'))
  end
end
