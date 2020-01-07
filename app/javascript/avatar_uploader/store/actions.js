import axios from 'lib/utils/axios_utils';
import * as types from './mutation_types';

export const setFileStatus = ({ commit }, status) => commit(types.SET_FILE_STATUS, status);

export const setImageSrc = ({ commit }, src) => commit(types.SET_IMAGE_SRC, src);

export const setHiddenImageSrc = ({ commit }, src) => commit(types.SET_HIDDEN_IMAGE_SRC, src);

export const receivePresignedPostError = ({ dispatch }, payload) => {
  const error = payload.error.response.data;
  dispatch('setFileStatus', Array.isArray(error) ? error.join(', ') : error);
};

export const receivePresignedPostSuccess = ({ dispatch }, payload) => {
  const { data, presignedPost } = payload;
  presignedPost['Content-Type'] = payload.file.type;

  data.formData = presignedPost;

  data
    .submit()
    .then(() => { })
    .catch(error => {
      dispatch('setFileStatus', error.responseXML.getElementsByTagName('Message')[0].innerHTML);
    });
};

export const requestPresignedPost = ({ dispatch }) => {
  dispatch('setFileStatus', 'Dosya yükleniyor...');
};

export const fetchPresignedPost = ({ dispatch }, payload) => {
  dispatch('requestPresignedPost');
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
      const errorPayload = Object.assign(payload, { error });
      dispatch('receivePresignedPostError', errorPayload);
    });
};
