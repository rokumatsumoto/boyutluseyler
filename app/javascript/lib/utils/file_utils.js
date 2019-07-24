function getFileExtension(filename) {
  const extension = filename.slice(((filename.lastIndexOf('.') - 1) >>> 0) + 2);
  if (extension !== '') {
    return extension;
  }
  return filename; // .xyz
}

export default getFileExtension;
