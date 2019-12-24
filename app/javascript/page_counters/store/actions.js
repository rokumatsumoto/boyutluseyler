import * as types from './mutation_types';

export const setDownloadsCount = ({ commit }, count) => commit(types.SET_DOWNLOADS_COUNT, count);

export const setLikesCount = ({ commit }, count) => commit(types.SET_LIKES_COUNT, count);

