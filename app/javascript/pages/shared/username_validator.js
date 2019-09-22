/* eslint-disable consistent-return, class-methods-use-this */

import axios from 'lib/utils/axios_utils';
import Noty from 'noty';

const UNAVAILABLE_MESSAGE_SELECTOR = '.username .validation-error';
const SUCCESS_MESSAGE_SELECTOR = '.username .validation-success';
const PENDING_MESSAGE_SELECTOR = '.username .validation-pending';
const YOURS_MESSAGE_SELECTOR = '.username .validation-yours';

const INVALID_INPUT_CLASS = 'is-invalid';
const SUCCESS_INPUT_CLASS = 'is-valid';

const INVALID_FORM_GROUP_CLASS = 'form-group-invalid';

export default class UsernameValidator {
  constructor() {
    this.inputElement = document.getElementById('user_username');
    if (this.inputElement != null) {
      // for Turbolinks
      this.state = {
        available: true,
        valid: false,
        pending: false,
        empty: true,
        yours: false,
      };
      this.inputElement.addEventListener('blur', this.usernameBlur.bind(this), false);

      this.form = this.inputElement.closest('form');
      this.form.addEventListener('submit', this.formSubmit.bind(this), false);
    }
  }

  usernameBlur() {
    const username = this.inputElement.value;
    // look parent node (div) for valid state
    // for presence, length and format validations we use client_side_validations gem
    this.state.valid = !this.inputElement.parentNode.classList.contains(INVALID_FORM_GROUP_CLASS);
    this.state.empty = !username.length;
    this.state.yours =
      this.inputElement.attributes.data_username !== undefined
        ? this.inputElement.attributes.data_username.value === this.inputElement.value
        : false;
    this.state.available = true;

    if (this.state.empty || !this.state.valid) {
      this.clearFieldValidationStateMessage();
    }

    if (this.state.yours) {
      this.renderState();
    }

    if (this.state.valid && !this.state.empty && !this.state.yours) {
      return this.validateUsername(username);
    }
  }

  formSubmit(event) {
    if (!this.state.available) {
      event.preventDefault();
      event.stopPropagation();
    }
  }

  renderState() {
    // Clear all state
    this.clearFieldValidationState();

    if (this.state.yours) {
      return this.setYoursState();
    }

    if (this.state.valid && this.state.available) {
      return this.setSuccessState();
    }

    if (this.state.empty) {
      return this.clearFieldValidationState();
    }

    if (this.state.pending) {
      return this.setPendingState();
    }

    if (this.state.valid && !this.state.yours && !this.state.available) {
      return this.setUnavailableState();
    }
  }

  validateUsername(username) {
    if (this.state.valid) {
      this.state.pending = true;
      this.state.available = false;
      this.renderState();
      axios
        .get(`/exists/${username}`)
        .then(({ data }) => this.setAvailabilityState(data.exists))
        .catch(error => {
          new Noty({
            type: 'error',
            layout: 'top',
            text: error.response.data.message,
          }).show();
        });
    }
  }

  setAvailabilityState(usernameTaken) {
    if (usernameTaken) {
      this.state.available = false;
    } else {
      this.state.available = true;
    }
    this.state.pending = false;
    this.renderState();
  }

  clearFieldValidationStateMessage() {
    $(this.inputElement.closest('div'))
      .children('div[class^="validation-"]')
      .hide();
  }

  clearFieldValidationState() {
    this.clearFieldValidationStateMessage();
    this.inputElement.classList.remove(INVALID_INPUT_CLASS, SUCCESS_INPUT_CLASS);
  }

  addSuccessClass() {
    this.inputElement.classList.add(SUCCESS_INPUT_CLASS);
    this.inputElement.classList.remove(INVALID_INPUT_CLASS);
  }

  setYoursState() {
    const $usernameYoursMessage = document.querySelector(YOURS_MESSAGE_SELECTOR);
    this.addSuccessClass();
    $usernameYoursMessage.style.display = 'block';
  }

  setSuccessState() {
    const $usernameSuccessMessage = document.querySelector(SUCCESS_MESSAGE_SELECTOR);
    this.addSuccessClass();
    $usernameSuccessMessage.style.display = 'block';
  }

  setPendingState() {
    const $usernamePendingMessage = document.querySelector(PENDING_MESSAGE_SELECTOR);
    if (this.state.pending) {
      $usernamePendingMessage.style.display = 'block';
    } else {
      $usernamePendingMessage.style.display = 'none';
    }
  }

  setUnavailableState() {
    const $usernameUnavailableMessage = document.querySelector(UNAVAILABLE_MESSAGE_SELECTOR);
    this.inputElement.classList.add(INVALID_INPUT_CLASS);
    this.inputElement.classList.remove(SUCCESS_INPUT_CLASS);
    $usernameUnavailableMessage.style.display = 'block';
  }
}
