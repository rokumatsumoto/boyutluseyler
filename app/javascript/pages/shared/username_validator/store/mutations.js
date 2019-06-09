import * as types from './mutation_types';
import {
  UNAVAILABLE_MESSAGE_SELECTOR,
  SUCCESS_MESSAGE_SELECTOR,
  PENDING_MESSAGE_SELECTOR,
  YOURS_MESSAGE_SELECTOR,
  INVALID_INPUT_CLASS,
  SUCCESS_INPUT_CLASS,
  INVALID_FORM_GROUP_CLASS,
  USERNAME_FORM_GROUP_CLASS,
} from '../constants';

export default {
  [types.SET_AVAILABLE_STATE](state, payload) {
    state.available = payload.available;
  },

  [types.SET_VALID_STATE](state, payload) {
    // look form group username element (div) for valid state
    // for presence, length and format validations we use client_side_validations gem
    state.valid = !payload.target.parentNode.classList.contains(INVALID_FORM_GROUP_CLASS);
  },

  [types.SET_PENDING_STATE](state, payload) {
    state.pending = payload.pending;
  },

  [types.SET_EMPTY_STATE](state, payload) {
    state.empty = !payload.target.value.length;
  },

  [types.SET_YOURS_STATE](state, payload) {
    state.yours =
      payload.target.attributes.data_username !== undefined
        ? payload.target.attributes.data_username.value === payload.target.value
        : false;
  },

  [types.CLEAR_FIELD_VALIDATION_STATE](state, payload) {
    $(payload.target.closest('div'))
      .siblings('p')
      .hide();
    payload.target.classList.remove(INVALID_INPUT_CLASS, SUCCESS_INPUT_CLASS);
  },

  [types.CLEAR_FIELD_VALIDATION_STATE_MESSAGE](state, payload) {
    $(payload.target.closest('div'))
      .siblings('p')
      .hide();
    // reset username form-group element margin-bottom value
    this.commit(types.SET_MARGIN_BOTTOM_USERNAME_FORM_GROUP, {
      margin: '1rem',
    });
  },

  [types.SET_MARGIN_BOTTOM_USERNAME_FORM_GROUP](state, payload) {
    document.getElementsByClassName(USERNAME_FORM_GROUP_CLASS)[0].style['margin-bottom'] =
      payload.margin;
  },

  [types.RENDER_PENDING_STATE](state) {
    const $usernamePendingMessage = document.querySelector(PENDING_MESSAGE_SELECTOR);
    if (state.pending) {
      $usernamePendingMessage.style.display = 'block';
      // fix state messages (pending, unavailable, available) positions
      this.commit(types.SET_MARGIN_BOTTOM_USERNAME_FORM_GROUP, {
        margin: 0,
      });
    } else {
      $usernamePendingMessage.style.display = 'none';
    }
  },

  [types.RENDER_AVAILABLE_STATE](state, payload) {
    const $usernameAvailableMessage = document.querySelector(SUCCESS_MESSAGE_SELECTOR);
    payload.target.classList.add(SUCCESS_INPUT_CLASS);
    payload.target.classList.remove(INVALID_INPUT_CLASS);
    $usernameAvailableMessage.style.display = 'block';
  },

  [types.RENDER_YOURS_STATE](state, payload) {
    const $usernameYoursMessage = document.querySelector(YOURS_MESSAGE_SELECTOR);
    payload.target.classList.add(SUCCESS_INPUT_CLASS);
    payload.target.classList.remove(INVALID_INPUT_CLASS);
    $usernameYoursMessage.style.display = 'block';
    // fix state message (yours) position
    this.commit(types.SET_MARGIN_BOTTOM_USERNAME_FORM_GROUP, {
      margin: 0,
    });
  },

  [types.RENDER_UNAVAILABLE_STATE](state, payload) {
    const $usernameUnavailableMessage = document.querySelector(UNAVAILABLE_MESSAGE_SELECTOR);
    payload.target.classList.add(INVALID_INPUT_CLASS);
    payload.target.classList.remove(SUCCESS_INPUT_CLASS);
    $usernameUnavailableMessage.style.display = 'block';
  },
};
