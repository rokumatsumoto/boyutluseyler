import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import store from './store'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const usernameElement = document.getElementById('user_username');
  if (usernameElement != null){
    const app = new Vue({
      store,
      el: '[data-behavior="vue"]',
      mounted() {
        // Accessing usernameElement above not trigger blur event
        this.getUsernameElement().addEventListener('blur', this.usernameCheck, false);
      },
      destroyed() {
        this.getUsernameElement().removeEventListener('blur', this.usernameCheck, false);
      },
      methods: {
        getUsernameElement(e) {
          return document.getElementById('user_username');
        },
        usernameCheck(e) {
          this.$store.dispatch('usernameCheck', {
            value: e.target.value,
            target: e.target
          });
        }
      }
    })
  }
})
