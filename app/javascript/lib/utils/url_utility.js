// @param {Object} params - url keys and value to merge
// @param {String} url
export function mergeUrlParams(params, url) {
  const re = /^([^?#]*)(\?[^#]*)?(.*)/;
  const merged = {};
  const urlParts = url.match(re);

  if (urlParts[2]) {
    urlParts[2]
      .substr(1)
      .split('&')
      .forEach(part => {
        if (part.length) {
          const kv = part.split('=');
          merged[decodeURIComponent(kv[0])] = decodeURIComponent(kv.slice(1).join('='));
        }
      });
  }

  Object.assign(merged, params);

  const query = Object.keys(merged)
    .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(merged[key])}`)
    .join('&');

  return `${urlParts[1]}?${query}${urlParts[3]}`;
}


/**
 * Removes specified query params from the url by returning a new url string that no longer
 * includes the param/value pair. If no url is provided, `window.location.href` is used as
 * the default value.
 *
 * @param {string[]} params - the query param names to remove
 * @param {string} [url=windowLocation().href] - url from which the query param will be removed
 * @returns {string} A copy of the original url but without the query param
 */
export function removeParams(params, url = window.location.href) {
  const [rootAndQuery, fragment] = url.split('#');
  const [root, query] = rootAndQuery.split('?');

  if (!query) {
    return url;
  }

  const encodedParams = params.map(param => encodeURIComponent(param));
  const updatedQuery = query
    .split('&')
    .filter(paramPair => {
      const [foundParam] = paramPair.split('=');
      return encodedParams.indexOf(foundParam) < 0;
    })
    .join('&');

  const writableQuery = updatedQuery.length > 0 ? `?${updatedQuery}` : '';
  const writableFragment = fragment ? `#${fragment}` : '';
  return `${root}${writableQuery}${writableFragment}`;
}
