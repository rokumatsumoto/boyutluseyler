import getFileExtension from 'lib/utils/file_utils';
import VALID_IMAGE_EXTENSIONS from '../constants';

export const contentCount = state => state.contents.length;

export const getContent = state => dataType => state.contents.find(c => c.dataType === dataType);

export const getActiveContentCount = state => state.contents.filter(c => c.active).length;

export const getFiles = state => content =>
  // https://jsonapi.org/format/
  content.files.data.filter(f => f.type === content.dataType).map(f => f.attributes);

export const getValidFiles = (state, getters) => content =>
  getters.getFiles(content).filter(f => {
    const validUrl =
      content.fileExtensions.length === 0 ||
      content.fileExtensions.includes(getFileExtension(f.url).toLowerCase());
    const validThumbUrl =
      f.thumbUrl === '' ||
      VALID_IMAGE_EXTENSIONS.includes(getFileExtension(f.thumbUrl).toLowerCase());
    return validUrl && validThumbUrl;
  }) || [];
