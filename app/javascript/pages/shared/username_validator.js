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

const USERNAME_FORM_GROUP_CLASS = 'form-group user_username';

export default class UsernameValidator {
  constructor() {
    this.inputElement = document.getElementById('user_username');
    if (this.inputElement != null) { // for Turbolinks
      this.state = {
        available: false,
        valid: false,
        pending: false,
        empty: true,
        yours: false,
      };
      this.inputElement.addEventListener('blur', this.usernameBlur.bind(this), false);
    }
  }

  usernameBlur() {
    const username = this.inputElement.value;
    // look form group username element (div) for valid state
    // for presence, length and format validations we use client_side_validations gem
    this.state.valid = !this.inputElement.parentNode.classList.contains(
      INVALID_FORM_GROUP_CLASS,
    );
    this.state.empty = !username.length;
    this.state.yours =
      this.inputElement.attributes.data_username !== undefined
        ? this.inputElement.attributes.data_username.value === this.inputElement.value
        : false;

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
      .siblings('p')
      .hide();

    this.setMarginBottomUsernameFormGroup('1rem');
  }

  setMarginBottomUsernameFormGroup(margin) {
    document.getElementsByClassName(USERNAME_FORM_GROUP_CLASS)[0].style['margin-bottom'] = margin;
  }

  clearFieldValidationState() {
    $(this.inputElement.closest('div'))
      .siblings('p')
      .hide();
    this.inputElement.classList.remove(INVALID_INPUT_CLASS, SUCCESS_INPUT_CLASS);
  }

  setYoursState() {
    const $usernameYoursMessage = document.querySelector(YOURS_MESSAGE_SELECTOR);
    this.inputElement.classList.add(SUCCESS_INPUT_CLASS);
    this.inputElement.classList.remove(INVALID_INPUT_CLASS);
    $usernameYoursMessage.style.display = 'block';
    // fix state message (yours) position
    this.setMarginBottomUsernameFormGroup(0);
  }

  setSuccessState() {
    const $usernameSuccessMessage = document.querySelector(SUCCESS_MESSAGE_SELECTOR);
    this.inputElement.classList.add(SUCCESS_INPUT_CLASS);
    this.inputElement.classList.remove(INVALID_INPUT_CLASS);
    $usernameSuccessMessage.style.display = 'block';
  }

  setPendingState() {
    const $usernamePendingMessage = document.querySelector(PENDING_MESSAGE_SELECTOR);
    if (this.state.pending) {
      $usernamePendingMessage.style.display = 'block';
      // fix state messages (pending, unavailable, available) positions
      this.setMarginBottomUsernameFormGroup(0);
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
