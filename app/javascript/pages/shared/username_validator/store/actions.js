import axios from 'lib/utils/axios_utils';
import Noty from 'noty';

export default {
  setValidState({ commit }, payload) {
    commit('setValidState', payload);
  },
  setEmptyState({ commit }, payload) {
    commit('setEmptyState', payload);
  },
  setPendingState({ commit }, payload) {
    commit('setPendingState', payload);
  },
  setAvailableState({ commit }, payload) {
    commit('setAvailableState', payload);
  },
  setAlreadyTakenState({ commit }, payload) {
    commit('setAlreadyTakenState', payload);
  },
  clearFieldValidationState({ commit }, payload) {
    commit('clearFieldValidationState', payload);
  },
  clearFieldValidationStateMessage({ commit }, payload) {
    commit('clearFieldValidationStateMessage', payload);
  },
  renderAlreadyTakenState({ commit }, payload) {
    commit('renderAlreadyTakenState', payload);
  },
  renderAvailableState({ commit }, payload) {
    commit('renderAvailableState', payload);
  },
  renderPendingState({ commit }, payload) {
    commit('renderPendingState', payload);
  },
  renderUnavailableState({ commit }, payload) {
    commit('renderUnavailableState', payload);
  },
  renderState({ dispatch, state }, payload){
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
  },
  setAvailabilityState({ dispatch }, payload){
    dispatch('setAvailableState', payload);
    dispatch('setPendingState', {
      pending: false
    });
    dispatch('renderState', payload);
  },
  usernameCheck ({ dispatch, state }, payload) {
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
  },
  validateUsername ({ dispatch }, payload) {
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
  }
}
