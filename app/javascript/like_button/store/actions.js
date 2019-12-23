import axios from 'lib/utils/axios_utils';
import eventHub from 'page_counters/components/event_hub';
import * as types from './mutation_types';

export const setLiked = ({ commit }, liked) => commit(types.SET_LIKED, liked);

export const receiveDeleteLikeError = ({ dispatch }, payload) => {
  // TODO: post error
};

export const receiveDeleteLike = ({ dispatch }) => {
  dispatch('setLiked', false);

  eventHub.$emit('unlike');
};

export const deleteLike = ({ dispatch }, payload) => {
  axios
    .delete(payload.endpoint)
    .then(response => {
      dispatch('receiveDeleteLike');
    })
    .catch(error => {
      const errorPayload = Object.assign(payload, { error });
      dispatch('receiveDeleteLikeError', errorPayload);
    });
};

export const receiveCreateLikeError = ({ dispatch }, payload) => {
  // TODO: post error
};

export const receiveCreateLike = ({ dispatch }) => {
  dispatch('setLiked', true);

  eventHub.$emit('like');
};

export const createNewLike = ({ dispatch }, payload) => {
  axios
    .post(payload.endpoint)
    .then(response => {
      dispatch('receiveCreateLike');
    })
    .catch(error => {
      const errorPayload = Object.assign(payload, { error });
      dispatch('receiveCreateLikeError', errorPayload);
    });
};
