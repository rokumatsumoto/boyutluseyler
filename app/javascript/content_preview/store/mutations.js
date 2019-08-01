import * as types from './mutation_types';

export default {
  [types.REGISTER_CONTENT](state, content) {
    state.contents.push(content);
  },

  [types.SET_ACTIVE_CONTENT](state, content) {
    state.contents = state.contents.map(c => {
      if (c.dataType !== content.dataType) {
        return Object.assign(c, {
          active: false,
        });
      }
      return Object.assign(c, {
        active: true,
      });
    });
    state.activeContent = content;
  },

  [types.SET_ACTIVE_CONTENT_COUNT](state, activeContentCount) {
    state.activeContentCount = activeContentCount;
    if (state.activeContentCount > 1) {
      throw new Error('Only one ContentPreview component can active at a time');
    }
  },
};
