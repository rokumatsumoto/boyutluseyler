import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import ConnectedUploader from 'connected_uploader/components/connected_uploader.vue'
// import store from './store';

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const $connectedUploaders = document.getElementsByClassName('js-connected-uploader');
  if ($connectedUploaders.length !== 0) {
    const app = new Vue({
      el: '[data-behavior="vue"]',
      components: { ConnectedUploader },
      methods: {
      },
    });
  }
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');
