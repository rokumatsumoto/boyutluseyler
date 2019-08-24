import BYTES_IN_KIB  from './constants';

export const numberToHumanSize = (size) => {
  if (size === 0) {
    return '0.00 B';
  }
  if (!size) {
    return null;
  }
  const e = Math.floor(Math.log(size) / Math.log(BYTES_IN_KIB));
  return `${(size / BYTES_IN_KIB ** e).toFixed(2)} ${' KMGTP'.charAt(e)}B`;
};

export const uuidV4 = () =>
  ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
    // eslint-disable-next-line no-bitwise
    (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
  )
