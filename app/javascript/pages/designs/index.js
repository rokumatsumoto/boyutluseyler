import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import ContentPreview from 'content_preview/components/content_preview.vue';
import ContentPreviewToggleButton from 'content_preview/components/content_preview_toggle_button.vue';
import createStore from 'content_preview/store';

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const $contentPreviews = document.getElementsByClassName('js-content-preview');
  if ($contentPreviews.length > 0) {
    Array.from($contentPreviews).forEach($contentPreview => {
      const app = new Vue({
        el: $contentPreview,
        store: createStore(),
        components: { ContentPreview, ContentPreviewToggleButton },
      });
    });
  }
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');
