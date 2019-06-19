import axios from 'lib/utils/axios_utils';
import * as types from './mutation_types';

export const dragOver = ({ commit }) => commit(types.DRAG_OVER);

export const dragLeave = ({ commit }) => commit(types.DRAG_LEAVE);

// export const receiveUsernameError = ({ dispatch }, payload) => {
//   dispatch('setPendingState', {
//     pending: false,
//   });
//   dispatch('clearFieldValidationState', payload);
//   dispatch('setMarginBottomUsernameFormGroup', {
//     margin: '1rem',
//   });
//   new Noty({
//     type: 'error',
//     layout: 'top',
//     text: payload.error.response.data.message,
//   }).show();
// };

// export const receiveUsernameSuccess = ({ dispatch }, payload) => {
//   dispatch('setAvailableState', payload);
//   dispatch('setPendingState', {
//     pending: false,
//   });
//   dispatch('renderState', payload);
// };

// export const requestUsername = ({ dispatch, state }, payload) => {
//   dispatch('setValidState', payload);
//   dispatch('setEmptyState', payload);
//   // reset availability state on every request
//   dispatch('setAvailableState', {
//     available: false,
//   });
//   dispatch('setYoursState', payload);

//   // let client_side_validations gem do his job
//   // (presence, length and format validations)
//   if (state.empty || !state.valid) {
//     dispatch('clearFieldValidationStateMessage', payload);
//   }
//   if (state.yours) {
//     dispatch('renderState', payload);
//   }
//   if (state.valid && !state.empty && !state.yours) {
//     dispatch('setPendingState', {
//       pending: true,
//     });
//     dispatch('renderState', payload);
//   }
// };

// export const fetchUsername = ({ dispatch, state }, payload) => {
//   dispatch('requestUsername', payload);
//   if (state.pending) {
//     axios
//       .get(`/exists/${payload.value}`)
//       .then(({ data }) =>
//         dispatch('receiveUsernameSuccess', {
//           available: !data.exists,
//           target: payload.target,
//         }),
//       )
//       .catch(error => {
//         const errorPayload = Object.assign(payload, { 'error': error });
//         dispatch('receiveUsernameError', errorPayload);
//       });
//   }
// };
