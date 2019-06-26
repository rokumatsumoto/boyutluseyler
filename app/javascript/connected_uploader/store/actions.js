import axios from 'lib/utils/axios_utils';
import * as types from './mutation_types';

export const dragOver = ({ commit }) => commit(types.DRAG_OVER);

export const dragLeave = ({ commit }) => commit(types.DRAG_LEAVE);

export const addFile = ({ commit }, fileInfo) => commit(types.ADD_FILE, fileInfo);

export const removeFile = ({ commit }, uniqueId) => commit(types.REMOVE_FILE, uniqueId);

export const updateFileList = ({ commit }, fileList) => commit(types.UPDATE_FILE_LIST, fileList);

export const setFileStatus = ({ commit }, payload) => commit(types.SET_FILE_STATUS, payload);

export const receivePresignedPostError = ({ dispatch }, payload) => {
  // TODO:
  //
  //
};

export const receivePresignedPostSuccess = ({ dispatch }, payload) => {
  const { data, presignedPost } = payload;
  presignedPost['Content-Type'] = payload.file.type;

  data.formData = presignedPost;
  data.submit();
};

export const requestPresignedPost = ({ dispatch }, uniqueId) => {
  dispatch('setFileStatus', {
    actionName: 'LOADING_FILE',
    uniqueId,
  });
};

export const fetchPresignedPost = ({ dispatch }, payload) => {
  dispatch('requestPresignedPost', payload.uniqueId);
  axios
    .get(payload.uploaderUrl)
    .then(({ data }) =>
      dispatch('receivePresignedPostSuccess', {
        presignedPost: data,
        data: payload.data,
        file: payload.file,
      }),
    )
    .catch(error => {
      // TODO:
      // const errorPayload = Object.assign(payload, { error: error });
      // dispatch('receiveFetchError', errorPayload);
    });
};

export const receiveCreateFileResourceError = ({ dispatch }, payload) => {
  //TODO:
  //
  //
};

export const receiveCreateFileResource = ({ dispatch }, payload) => {
  dispatch('setFileStatus', {
    actionName: 'FILE_DONE',
    uniqueId: payload.uniqueId,
    id: payload.id,
  });
};

export const createNewFileResource = ({ dispatch }, payload) => {
  axios
    .post(payload.createUrl, {
      illustration: { key: payload.key },
    })
    .then(response => {
      dispatch('receiveCreateFileResource', {
        id: response.data.id,
        uniqueId: payload.uniqueId,
      });
    })
    .catch(() => {
      dispatch('receiveCreateFileResourceError');
    });
};
