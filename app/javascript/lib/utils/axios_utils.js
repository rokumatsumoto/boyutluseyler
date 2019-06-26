import axios from 'axios';
import csrf from './csrf';

axios.defaults.headers.common[csrf.headerKey] = csrf.token;
// Used by Rails to check if it is a valid XHR request
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

// Maintain a global counter for active requests
// see: spec/support/helpers/wait_for_requests.rb
axios.interceptors.request.use(config => {
  window.activeAxios = window.activeAxios || 0;
  window.activeAxios += 1;

  return config;
});

// Remove the global counter
axios.interceptors.response.use(
  config => {
    window.activeAxios -= 1;

    return config;
  },
  e => {
    window.activeAxios -= 1;

    if (e.response.status === 401) {
      const $notyNotification = document.getElementById('noty_notification');
      if ($notyNotification === null) {
        import('noty')
          .then((Noty) => {
            /* eslint-disable-next-line new-cap */
            new Noty.default({
              type: 'warning',
              layout: 'top',
              id: 'noty_notification',
              timeout: 4000,
              progressBar: true,
              text: "Oturumunuzun süresi doldu, giriş sayfasına yönlendiriliyorsunuz.",
              callbacks: {
                afterClose() {
                  window.location.href = '/sign_in';
                },
              },
            }).show();
          })
          .catch(() => {
            window.location.href = '/sign_in';
          });
      }
    }
    return Promise.reject(e);
  },
);

export default axios;

// axios-mock-adapter: https://github.com/ctimmerm/axios-mock-adapter
// axios adapters: https://github.com/axios/axios/tree/master/lib/adapters
// How can you use axios interceptors?
// https://stackoverflow.com/questions/52737078/how-can-you-use-axios-interceptors
