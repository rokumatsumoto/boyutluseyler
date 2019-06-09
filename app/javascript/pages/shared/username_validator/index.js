import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import store from './store';

require('rails.validations');
require('rails.validations.simple_form.bootstrap4');

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const usernameElement = document.getElementById('user_username');
  if (usernameElement != null) {
    const app = new Vue({
      store,
      el: '[data-behavior="vue"]',
      mounted() {
        this.getUsernameElement().addEventListener('blur', this.fetchUsername, false);
        Vue.nextTick(() => {
          $(this.getUsernameElement()).enableClientSideValidations();
        });
      },
      destroyed() {
        this.getUsernameElement().removeEventListener('blur', this.fetchUsername, false);
      },
      methods: {
        getUsernameElement() {
          return document.getElementById('user_username');
        },
        fetchUsername(e) {
          this.$store.dispatch('fetchUsername', {
            value: e.target.value,
            target: e.target,
          });
        },
      },
    });
  }
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');
