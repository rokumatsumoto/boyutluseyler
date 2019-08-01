import * as types from './mutation_types';

export const registerContent = ({ commit, getters, dispatch }, content) => {
  Object.assign(content, {
    files: getters.getValidFiles(content),
  });
  if (content.files.length > 0) {
    commit(types.REGISTER_CONTENT, content);

    if (content.active) {
      dispatch('setActiveContent', content);
    }
  }
};

export const setActiveContent = ({ commit, dispatch }, content) => {
  dispatch('setActiveContentCount');
  commit(types.SET_ACTIVE_CONTENT, content);
};

export const setActiveContentCount = ({ commit, getters }) => {
  commit(types.SET_ACTIVE_CONTENT_COUNT, getters.getActiveContentCount);
};
