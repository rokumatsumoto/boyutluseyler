import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import ContentPreview from 'content_preview/components/content_preview.vue';
import ContentPreviewToggleButton from 'content_preview/components/content_preview_toggle_button.vue';
import DownloadButton from 'download_button/components/download_button.vue';
import PageCounters from 'page_counters/components/page_counters.vue';
import createContentPreviewStore from 'content_preview/store';
import createDownloadButtonStore from 'download_button/store';
import createPageCountersStore from 'page_counters/store';
import ActionCableVue from 'actioncable-vue';

Vue.use(TurbolinksAdapter);
Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'all',
  connectionUrl: gon.websocketServerUrl,
  connectImmediately: true
});

document.addEventListener('turbolinks:load', () => {
  const $contentPreviews = document.getElementsByClassName('js-content-preview');
  if ($contentPreviews.length > 0) {
    Array.from($contentPreviews).forEach($contentPreview => {
      const app = new Vue({
        el: $contentPreview,
        store: createContentPreviewStore(),
        components: { ContentPreview, ContentPreviewToggleButton },
      });
    });
  }

  const $downloadButtons = document.getElementsByClassName('js-download-button');
  if ($downloadButtons.length > 0) {
    Array.from($downloadButtons).forEach($downloadButton => {
      const app = new Vue({
        el: $downloadButton,
        store: createDownloadButtonStore(),
        components: { DownloadButton },
      });
    });
  }

  const $pageCounters = document.getElementsByClassName('js-page-counters');
  if ($pageCounters.length > 0) {
    Array.from($pageCounters).forEach($pageCounter => {
      const app = new Vue({
        el: $pageCounter,
        store: createPageCountersStore(),
        components: { PageCounters },
      });
    });
  }


});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');
