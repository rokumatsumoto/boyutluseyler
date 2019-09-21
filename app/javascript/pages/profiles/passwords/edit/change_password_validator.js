/* eslint-disable consistent-return */

const INVALID_MESSAGE_SELECTOR = '.current_password .validation-error';

const INVALID_INPUT_CLASS = 'is-invalid';
const SUCCESS_INPUT_CLASS = 'is-valid';

export default class ChangePasswordValidator {
  constructor() {
    this.form = $('#edit_user');
    if (this.form != null) { // for Turbolinks
      this.password = $('#user_password');
      this.passwordConfirmation = $('#user_password_confirmation');
      this.currentPassword = $('#user_current_password');

      this.form.on('submit', this.formSubmit.bind(this));
      this.currentPassword.on('blur', this.currentPasswordBlur.bind(this));
    }
  }

  formSubmit(event) {
    if (this.passwordChange() && this.currentPasswordIsBlank()) {
      this.setInvalidState();
      event.stopImmediatePropagation();
      return false;
    }
  }

  currentPasswordBlur() {
    if (!this.currentPasswordIsBlank()) {
      this.clearFieldValidationState();
    }
  }

  passwordChange() {
    return this.password.val().trim().length > 0 &&
           this.passwordConfirmation.val().trim().length > 0
  }

  currentPasswordIsBlank() {
    return this.currentPassword.val().trim() === ''
  }

  setInvalidState() {
    const $inputErrorMessage = $(INVALID_MESSAGE_SELECTOR);
    this.currentPassword.addClass(INVALID_INPUT_CLASS).removeClass(SUCCESS_INPUT_CLASS);
    $inputErrorMessage.show();
  }

  clearFieldValidationState() {
    this.currentPassword.closest('div').siblings('p').hide();
    this.currentPassword.removeClass(INVALID_INPUT_CLASS).removeClass(SUCCESS_INPUT_CLASS);
  }
}
