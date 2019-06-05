import axios from 'lib/utils/axios_utils';
import Noty from 'noty';

export default {
  usernameCheck ({ dispatch, commit, state }, payload) {
    commit('setValidState', payload);
    commit('setEmptyState', payload);
    // reset availability state to false on every request
    commit('setAvailabilityState', {
      available: false
    });
    commit('setAlreadyTakenState', payload);

    // let client_side_validations gem do his job
    // (presence, length and format validations)
    if (state.empty || !state.valid) {
      commit('clearFieldValidationStateMessage', payload);
    }
    if (state.alreadyTaken) {
      dispatch('renderState', payload);
    }
    if (state.valid && !state.empty && !state.alreadyTaken) {
      dispatch('renderState', payload);
      dispatch('validateUsername', payload);
    }
  },
  validateUsername ({ dispatch, commit }, payload) {
    commit('setPendingState', {
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
          type: "error",
          layout: "top",
          text: error.response.data.message,
        }).show();
      });
  },
  renderState({ commit, state }, payload){
    commit('clearFieldValidationState', payload);

    if (state.alreadyTaken) {
      commit('renderAlreadyTakenState', payload);
    }
    if (state.available) {
      commit('renderAvailableState', payload);
    }
    if (state.empty) {
      commit('clearFieldValidationState', payload);
    }
    if (state.pending) {
      commit('renderPendingState', payload);
    }
    if (!state.pending && !state.alreadyTaken && !state.available) {
      commit('renderUnavailableState', payload);
    }
  },
  setAvailabilityState({ commit, dispatch }, payload){
    commit('setAvailabilityState', payload);
    commit('setPendingState', {
      pending: false
    });
    dispatch('renderState', payload);
  }

}
