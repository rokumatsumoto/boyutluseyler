export const getOriginFiles = state => (files, dataType) =>
  // https://jsonapi.org/format/
  files.data.filter(f => f.type === dataType).map(f => f.attributes);


