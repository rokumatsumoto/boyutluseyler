import getFileExtension from 'lib/utils/file_utils';
import VALID_IMAGE_EXTENSIONS from '../constants';

export const contentCount = state => state.contents.length;

export const getContent = state => dataType => state.contents.find(c => c.dataType === dataType);

export const getActiveContentCount = state => state.contents.filter(c => c.active).length;

export const getValidFiles = state => content =>
  content.files.filter(f => {
    const validUrl =
      content.fileExtensions.length === 0 ||
      content.fileExtensions.includes(getFileExtension(f.url).toLowerCase());
    const validImageUrl =
      f.imageUrl === '' ||
      VALID_IMAGE_EXTENSIONS.includes(getFileExtension(f.imageUrl).toLowerCase());
    return validUrl && validImageUrl;
  }) || [];


