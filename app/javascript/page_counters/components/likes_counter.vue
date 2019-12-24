<script>
import counterMixin from 'page_counters/mixins/counter_mixin';
import { mapActions } from 'vuex';
import eventHub from './event_hub';

export default {
  name: 'LikesCounter',
  mixins: [counterMixin],
  created() {
    eventHub.$on('like', this.incrementCounter);
    eventHub.$on('unlike', this.decrementCounter);
  },
  beforeDestroy() {
    eventHub.$off('like', this.incrementCounter);
    eventHub.$off('unlike', this.decrementCounter);
  },
  methods: {
    ...mapActions(['setLikesCount']),
    incrementCounter() {
      let likesCount = this.count;
      this.setLikesCount((likesCount += 1));
    },
    decrementCounter() {
      let likesCount = this.count;
      this.setLikesCount((likesCount -= 1));
    },
  },
};
</script>
<template>
  <span v-if="showCounter" data-toggle="tooltip" data-placement="bottom" :title="counterTooltip">
    <i class="fas fa-heart mr-1"></i>
    {{ localeCount }}
  </span>
</template>
