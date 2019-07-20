import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import ConnectedUploader from 'connected_uploader/components/connected_uploader.vue';
import createStore from 'connected_uploader/store';

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const $connectedUploaders = document.getElementsByClassName('js-connected-uploader');
  if ($connectedUploaders.length !== 0) {
    Array.from($connectedUploaders).forEach($connectedUploader => {
      const app = new Vue({
        el: $connectedUploader,
        store: createStore(),
        components: { ConnectedUploader },
      });
    });
  }
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');
