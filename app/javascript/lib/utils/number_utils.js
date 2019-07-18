import BYTES_IN_KIB  from './constants';

function numberToHumanSize(size) {
  if (size === 0) {
    return '0.00 B';
  }
  if (!size) {
    return null;
  }
  const e = Math.floor(Math.log(size) / Math.log(BYTES_IN_KIB));
  return `${(size / BYTES_IN_KIB ** e).toFixed(2)} ${' KMGTP'.charAt(e)}B`;
}

export default numberToHumanSize;
