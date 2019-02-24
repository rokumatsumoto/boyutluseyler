module LoginHelpers
  # Internal: Log in as a specific user or a new user of a specific role
  #
  # user_or_role - User object, or a role to create (e.g., :admin, :user)
  #
  # Examples:
  #
  #   # Create a user automatically
  #   boyutluseyler_sign_in(:user)
  #
  #   # Create an admin automatically
  #   boyutluseyler_sign_in(:admin)
  #
  #   # Provide an existing User record
  #   user = create(:user)
  #   boyutluseyler_sign_in(user)
  def boyutluseyler_sign_in(user_or_role, **kwargs)
    user =
      if user_or_role.is_a?(User)
        user_or_role
      else
        create(user_or_role)
      end

    boyutluseyler_sign_in_with(user, **kwargs)

    @current_user = user
  end

  private

  # Private: Login as the specified user
  #
  # user     - User instance to login with
  # remember - Whether or not to check 'Remember me' (default: false)
  def boyutluseyler_sign_in_with(user, remember: false)
    visit new_user_session_path

    fill_in 'user_login', with: user.email
    fill_in 'user_password', with: '123456'
    check 'user_remember_me' if remember

    click_button 'btn_sign_in'
  end
end
