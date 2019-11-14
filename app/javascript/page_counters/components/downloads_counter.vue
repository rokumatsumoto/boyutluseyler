<script>
import counterMixin from 'page_counters/mixins/counter_mixin';
import { mapActions } from 'vuex';
import eventHub from './event_hub';

export default {
  name: 'DownloadsCounter',
  mixins: [counterMixin],
  props: {
    min: {
      type: Number,
      required: true,
    },
  },
  created() {
    eventHub.$on('download', this.incrementCounter);
  },
  beforeDestroy() {
    eventHub.$off('download', this.incrementCounter);
  },
  computed: {
    showCounter() {
      return this.count >= this.min;
    },
  },
  methods: {
    ...mapActions(['setDownloadsCount']),
    incrementCounter() {
      let downloadsCount = this.count;
      this.setDownloadsCount(downloadsCount += 1);
    },
  }
}
</script>
<template>
  <span v-if="showCounter" data-toggle="tooltip" data-placement="bottom" :title="counterTooltip">
    <i class="fas fa-cloud-download-alt mr-1"></i>
    {{ localeCount }}
  </span>
</template>
