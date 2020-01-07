import * as types from './mutation_types';

export default {
  [types.SET_FILE_STATUS](state, fileStatus) {
    Object.assign(state, { fileStatus });
  },

  [types.SET_IMAGE_SRC](state, imageSrc) {
    Object.assign(state, { imageSrc });
  },

  [types.SET_HIDDEN_IMAGE_SRC](state, hiddenImageSrc) {
    Object.assign(state, { hiddenImageSrc });
  },
};
