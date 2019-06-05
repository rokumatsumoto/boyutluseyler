import {
  UNAVAILABLE_MESSAGE_SELECTOR,
  SUCCESS_MESSAGE_SELECTOR,
  PENDING_MESSAGE_SELECTOR,
  ALREADY_TAKEN_MESSAGE_SELECTOR,
  INVALID_INPUT_CLASS,
  SUCCESS_INPUT_CLASS,
  INVALID_FORM_GROUP_CLASS,
  USERNAME_FORM_GROUP_CLASS
} from '../constants';

export default {
  setAvailableState(state, payload) {
    state.available = payload.available;
  },
  setValidState(state, payload) {
    // look form group username element (div) for valid state
    // for presence, length and format validations we use client_side_validations gem
    state.valid = !payload.target.parentNode.classList.contains(INVALID_FORM_GROUP_CLASS);
  },
  setPendingState(state, payload) {
    state.pending = payload.pending;
  },
  setEmptyState(state, payload) {
    state.empty = !payload.target.value.length;
  },
  setAlreadyTakenState(state, payload) {
    state.alreadyTaken = payload.target.attributes.data_username !== undefined ?
      payload.target.attributes.data_username.value == payload.target.value : false;
  },
  clearFieldValidationState(state, payload){
    $(payload.target.closest('div')).siblings('p').hide();
    payload.target.classList.remove(INVALID_INPUT_CLASS, SUCCESS_INPUT_CLASS);
  },
  clearFieldValidationStateMessage(state, payload){
    $(payload.target.closest('div')).siblings('p').hide();
    // reset username form-group element margin-bottom value
    this.commit('setMarginBottomUsernameFormGroup', {
      margin: '1rem'
    });
  },
  setMarginBottomUsernameFormGroup(state, payload) {
    document.getElementsByClassName(USERNAME_FORM_GROUP_CLASS)[0].style['margin-bottom'] = payload.margin;
  },
  renderPendingState(state, payload) {
    const $usernamePendingMessage = document.querySelector(PENDING_MESSAGE_SELECTOR);
    if (state.pending) {
      $usernamePendingMessage.style.display = 'block';
      // fix state messages (pending, unavailable, available) positions
      this.commit('setMarginBottomUsernameFormGroup', {
        margin: 0
      });
    } else {
      $usernamePendingMessage.style.display = 'none';
    }
  },
  renderAvailableState(state, payload) {
    const $usernameAvailableMessage = document.querySelector(SUCCESS_MESSAGE_SELECTOR);
    payload.target.classList.add(SUCCESS_INPUT_CLASS);
    payload.target.classList.remove(INVALID_INPUT_CLASS);
    $usernameAvailableMessage.style.display = 'block';
  },
  renderAlreadyTakenState(state, payload) {
    const $usernameAlreadyTakenMessage = document.querySelector(ALREADY_TAKEN_MESSAGE_SELECTOR);
    payload.target.classList.add(SUCCESS_INPUT_CLASS);
    payload.target.classList.remove(INVALID_INPUT_CLASS);
    $usernameAlreadyTakenMessage.style.display = 'block';
    // fix state message (already taken) position
    this.commit('setMarginBottomUsernameFormGroup', {
      margin: 0
    });
  },
  renderUnavailableState(state, payload) {
    const $usernameUnavailableMessage = document.querySelector(UNAVAILABLE_MESSAGE_SELECTOR);
    payload.target.classList.add(INVALID_INPUT_CLASS);
    payload.target.classList.remove(SUCCESS_INPUT_CLASS);
    $usernameUnavailableMessage.style.display = 'block';
  }
}
