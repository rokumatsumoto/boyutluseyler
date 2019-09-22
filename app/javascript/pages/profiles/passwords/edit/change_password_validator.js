/* eslint-disable consistent-return, class-methods-use-this */

const INVALID_MESSAGE_SELECTOR = 'div[class^="validation-"]';

const INVALID_INPUT_CLASS = 'is-invalid';
const SUCCESS_INPUT_CLASS = 'is-valid';

const FORM_SELECTOR = 'edit_user';

export default class ChangePasswordValidator {
  constructor() {
    const forms = document.getElementsByClassName(FORM_SELECTOR);
    if (forms.length > 0) {
      // for Turbolinks
      // eslint-disable-next-line prefer-destructuring
      this.form = forms[0];
      this.form.addEventListener('submit', this.formSubmit.bind(this), false);

      this.getPasswordFields().forEach(element => {
        element.addEventListener('blur', this.elementBlur.bind(this), false);
      });
    }
  }

  getPasswordFields() {
    return Array.from($(`.${FORM_SELECTOR} *`).filter(':input[type=password]'));

    // https://caniuse.com/#feat=rest-parameters
    // TODO: remove jquery
    // rest-parameters not supported on ios safari <= 10.3.3
    // return [...this.form.elements].filter(element => {
    //   return element.type === 'password'
    // });
  }

  formSubmit(event) {
    this.getPasswordFields().forEach(element => {
      if (this.elementIsBlank(element)) {
        this.setInvalidState(element);
        event.preventDefault();
        event.stopPropagation();
      }
    });
  }

  elementBlur(event) {
    if (!this.elementIsBlank(event.target)) {
      this.clearFieldValidationState(event.target);
    } else {
      this.setInvalidState(event.target);
    }
  }

  elementIsBlank(element) {
    return element.value.trim() === '';
  }

  getInputErrorMessage(element) {
    return element.closest('div').querySelector(INVALID_MESSAGE_SELECTOR);
  }

  setInvalidState(element) {
    const $inputErrorMessage = this.getInputErrorMessage(element);

    element.classList.add(INVALID_INPUT_CLASS);
    element.classList.remove(SUCCESS_INPUT_CLASS);

    $inputErrorMessage.style.display = 'block';
  }

  clearFieldValidationState(element) {
    const $inputErrorMessage = this.getInputErrorMessage(element);

    element.classList.remove(INVALID_INPUT_CLASS, SUCCESS_INPUT_CLASS);

    $inputErrorMessage.style.display = 'none';
  }
}
