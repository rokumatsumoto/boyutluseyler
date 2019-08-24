function getFileExtension(filename) {
  if (filename === undefined || filename === '') {
    return '';
  }
  // eslint-disable-next-line no-bitwise
  const extension = filename.slice(((filename.lastIndexOf('.') - 1) >>> 0) + 2);
  if (extension !== '') {
    return extension;
  }
  return filename; // .xyz
}

export default getFileExtension;
