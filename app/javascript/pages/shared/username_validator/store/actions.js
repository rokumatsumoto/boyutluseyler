import axios from 'lib/utils/axios_utils';
import Noty from 'noty';
import * as types from './mutation_types';

export const setValidState = ({ commit }, payload) => commit(types.SET_VALID_STATE, payload);

export const setEmptyState = ({ commit }, payload) => commit(types.SET_EMPTY_STATE, payload);

export const setPendingState = ({ commit }, payload) => commit(types.SET_PENDING_STATE, payload);

export const setAvailableState = ({ commit }, payload) => commit(types.SET_AVAILABLE_STATE, payload);

export const setAlreadyTakenState = ({ commit }, payload) =>
  commit(types.SET_ALREADY_TAKEN_STATE, payload);

export const clearFieldValidationState = ({ commit }, payload) =>
  commit(types.CLEAR_FIELD_VALIDATION_STATE, payload);

export const clearFieldValidationStateMessage = ({ commit }, payload) =>
  commit(types.CLEAR_FIELD_VALIDATION_STATE_MESSAGE, payload);

export const renderAlreadyTakenState = ({ commit }, payload) =>
  commit(types.RENDER_ALREADY_TAKEN_STATE, payload);

export const renderAvailableState = ({ commit }, payload) =>
  commit(types.RENDER_AVAILABLE_STATE, payload);

export const renderPendingState = ({ commit }, payload) =>
  commit(types.RENDER_PENDING_STATE, payload);

export const renderUnavailableState = ({ commit }, payload) =>
  commit(types.RENDER_UNAVAILABLE_STATE, payload);

export const renderState = ({ dispatch, state }, payload) => {
  dispatch('clearFieldValidationState', payload);

  if (state.alreadyTaken) {
    dispatch('renderAlreadyTakenState', payload);
  }
  if (state.available) {
    dispatch('renderAvailableState', payload);
  }
  if (state.empty) {
    dispatch('clearFieldValidationState', payload);
  }
  if (state.pending) {
    dispatch('renderPendingState', payload);
  }
  if (!state.pending && !state.alreadyTaken && !state.available) {
    dispatch('renderUnavailableState', payload);
  }
};

export const setAvailabilityState = ({ dispatch }, payload) =>  {
  dispatch('setAvailableState', payload);
  dispatch('setPendingState', {
    pending: false
  });
  dispatch('renderState', payload);
};

export const validateUsername = ({ dispatch }, payload) => {
  dispatch('setPendingState', {
    pending: true
  });
  dispatch('renderState', payload);
  axios
    .get(`/exists/${payload.value}`)
    .then(({ data }) => dispatch('setAvailabilityState', {
      available: !data.exists,
      target: payload.target
    }))
    .catch((error) => {
      new Noty({
        type: 'error',
        layout: 'top',
        text: error.response.data.message,
      }).show();
    });
};

export const usernameCheck = ({ dispatch, state }, payload) => {
  dispatch('setValidState', payload);
  dispatch('setEmptyState', payload);
  // reset availability state to false on every request
  dispatch('setAvailableState', {
    available: false
  });
  dispatch('setAlreadyTakenState', payload);

  // let client_side_validations gem do his job
  // (presence, length and format validations)
  if (state.empty || !state.valid) {
    dispatch('clearFieldValidationStateMessage', payload);
  }
  if (state.alreadyTaken) {
    dispatch('renderState', payload);
  }
  if (state.valid && !state.empty && !state.alreadyTaken) {
    dispatch('validateUsername', payload);
  }
};
