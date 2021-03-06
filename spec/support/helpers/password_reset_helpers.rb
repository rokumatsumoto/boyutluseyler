module PasswordResetHelpers
  def forgot_password(user, user_reload = true)
    visit new_user_password_path
    fill_in 'user_email', with: user.email
    click_button 'btn_forgot_password'
    user.reload if user_reload
  end

  def render_change_password_with_valid_token(user)
    token = user.send_reset_password_instructions

    visit(edit_user_password_path(reset_password_token: token))

    expect(page).not_to have_current_path new_user_password_url(user_email: user['email'])
  end

  def change_password(user)
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'btn_reset_password'
  end

  def reset_password_within_two_days
    allow(Devise).to receive(:reset_password_within).and_return(2.days)
  end

  def expired_message_for_reset_password_token
    t('errors.messages.expired', attribute:
      t('activerecord.attributes.user.reset_password_token'))
  end

  def invalid_message_for_reset_password_token
    t('errors.messages.invalid', attribute:
      t('activerecord.attributes.user.reset_password_token'))
  end
end
