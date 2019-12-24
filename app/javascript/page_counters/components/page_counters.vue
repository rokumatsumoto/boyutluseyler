<script>
import ViewsCounter from 'page_counters/components/views_counter.vue';
import DownloadsCounter from 'page_counters/components/downloads_counter.vue';
import LikesCounter from 'page_counters/components/likes_counter.vue';
import { numberToLocale } from 'lib/utils/number_utils';
import { mapState, mapActions } from 'vuex';

export default {
  name: 'PageCounters',
  components: {
    ViewsCounter,
    DownloadsCounter,
    LikesCounter,
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
    likes: {
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
    ...mapState(['downloadsCount', 'likesCount']),
    viewsLocaleCount() {
      return numberToLocale(this.views.count, this.locale);
    },
    downloadsLocaleCount() {
      return numberToLocale(this.downloadsCount, this.locale);
    },
    likesLocaleCount() {
      return numberToLocale(this.likesCount, this.locale);
    },
  },
  created() {
    this.setDownloadsCount(this.downloads.count);
    this.setLikesCount(this.likes.count);
  },
  methods: {
    ...mapActions(['setDownloadsCount', 'setLikesCount']),
    objectNotEmpty(obj) {
      return Object.keys(obj).length !== 0;
    },
    hasCounter(counter) {
      return this.objectNotEmpty(counter);
    },
  },
};
</script>

<template>
  <ul class="inline-list inline-list--spaced">
    <li v-if="hasCounter(views)">
      <views-counter
        :count="views.count"
        :locale-count="viewsLocaleCount"
        :min="views.min"
        :text-plural="views.textPlural"
        :text-singular="views.textSingular"
      />
    </li>
    <li v-if="hasCounter(likes)">
      <likes-counter
        :count="likesCount"
        :locale-count="likesLocaleCount"
        :min="likes.min"
        :text-plural="likes.textPlural"
        :text-singular="likes.textSingular"
      />
    </li>
    <li v-if="hasCounter(downloads)">
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
