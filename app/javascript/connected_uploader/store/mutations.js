import * as types from './mutation_types';

export default {
  [types.DRAG_OVER](state) {
    state.hovering = true;
  },

  [types.DRAG_LEAVE](state) {
    state.hovering = false;
  },

  [types.ADD_FILE](state, fileInfo) {
    state.files = state.files.concat([
      {
        uniqueId: fileInfo.uniqueId,
        filename: fileInfo.filename,
        size: fileInfo.size,
        error: null,
        loaded: 0,
        loading: false,
        url: null,
        image: null,
      },
    ]);
  },

  [types.REMOVE_FILE](state, uniqueId) {
    state.files = state.files.filter(file => file.uniqueId !== uniqueId);
  },

  [types.UPDATE_FILE_LIST](state, fileList) {
    state.files = fileList;
  },

  [types.SET_FILE_STATUS](state, payload) {
    state.files = state.files.map(file => {
      if (file.uniqueId !== payload.uniqueId) {
        return file;
      }
      let updatedFile = file;
      switch (payload.actionName) {
        case 'ERROR_FILE':
          console.log('error');
          updatedFile = Object.assign(file, { error: payload.error }, { loading: false });
          break;
        case 'LOADING_FILE':
          console.log('loading');
          updatedFile = Object.assign(file, { loading: true });
          break;
        case 'PROGRESS_FILE':
          console.log('progress');
          updatedFile = Object.assign(file, { loaded: payload.loaded });
          break;
        case 'FILE_DONE':
          console.log('done');
          updatedFile = Object.assign(file, { loading: false }, { id: payload.id });
          break;
        default:
          console.log('default');
      }
      return updatedFile;
    });
  },
};
