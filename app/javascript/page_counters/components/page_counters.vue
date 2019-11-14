<script>
import ViewsCounter from 'page_counters/components/views_counter.vue';
import DownloadsCounter from 'page_counters/components/downloads_counter.vue';
import { numberToLocale } from 'lib/utils/number_utils';
import { mapState, mapActions } from 'vuex';

export default {
  name: 'PageCounters',
  components: {
    ViewsCounter,
    DownloadsCounter,
  },
  props: {
    views: {
      type: Object,
      default: () => ({}),
      required: false,
    },
    downloads: {
      type: Object,
      default: () => ({}),
      required: false,
    },
    locale: {
      type: String,
      required: true,
    },
  },
  computed: {
    ...mapState(['downloadsCount']),
    viewsCount() {
      return this.views.count;
    },
    viewsLocaleCount() {
      return numberToLocale(this.viewsCount, this.locale);
    },
    downloadsLocaleCount() {
      return numberToLocale(this.downloadsCount, this.locale);
    },
    hasPageView() {
      return this.objectNotEmpty(this.views) &&
             this.viewsCount >= this.views.min
    },
    hasDownload() {
      return this.objectNotEmpty(this.downloads)
    },
  },
  created() {
    this.setDownloadsCount(this.downloads.count);
  },
  methods: {
    ...mapActions(['setDownloadsCount']),
    objectNotEmpty(obj) {
      return Object.keys(obj).length !== 0
    },
  },
};
</script>

<template>
  <ul class="inline-list inline-list--spaced">
    <li v-if="hasPageView">
      <views-counter
        :count="viewsCount"
        :locale-count="viewsLocaleCount"
        :text-plural="views.textPlural"
        :text-singular="views.textSingular"
      />
    </li>
    <li v-if="hasDownload">
      <downloads-counter
        :count="downloadsCount"
        :locale-count="downloadsLocaleCount"
        :min="downloads.min"
        :text-plural="downloads.textPlural"
        :text-singular="downloads.textSingular"
      />
    </li>
  </ul>
</template>
