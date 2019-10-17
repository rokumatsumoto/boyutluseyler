import axios from 'lib/utils/axios_utils';
import * as types from './mutation_types';

export const setDownloading = ({ commit }, isDownloading) => commit(types.SET_DOWNLOADING, isDownloading);

export const receiveDownloadUrlError = ({ dispatch }, payload) => {
  // TODO: fetch error
};

export const receiveDownloadUrlSuccess = ({ dispatch }, payload) => {
  const { url, vm } = payload;

  if (url && url !== '') {
    vm.$cable.unsubscribe('DownloadChannel');
    window.location = url;

    dispatch('setDownloading', false);
  }
};

export const requestDownloadUrl = ({ dispatch }, payload) => {
  const { recordId, vm } = payload;
  // `this._vm` not working here
  vm.addDownloadChannel();
  vm.$cable.subscribe({ channel: 'DownloadChannel', id: recordId });

  dispatch('setDownloading', true);
};

export const fetchDownloadUrl = ({ dispatch }, payload) => {
  dispatch('requestDownloadUrl', {
    recordId: payload.recordId,
    vm: payload.vm,
  });
  axios
    .get(payload.endpoint)
    .then(({ data }) => {
      const { url } = data;
      dispatch('receiveDownloadUrlSuccess', {
        url,
        vm: payload.vm,
      });
    })
    .catch(error => {
      const errorPayload = Object.assign(payload, { error });
      dispatch('receiveDownloadUrlError', errorPayload);
    });
};
