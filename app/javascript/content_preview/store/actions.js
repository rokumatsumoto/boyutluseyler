import * as types from './mutation_types';

export const registerContent = ({ dispatch, commit }, content) =>  {
  if (content.active) {
    dispatch('setActiveContent', content);
  }
  commit(types.REGISTER_CONTENT, content);
}

export const setActiveContent = ({ commit }, content) => {
  commit(types.SET_ACTIVE_CONTENT, content);
};
