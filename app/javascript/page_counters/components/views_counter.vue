<script>
import counterMixin from 'page_counters/mixins/counter_mixin';

export default {
  name: 'ViewsCounter',
  mixins: [counterMixin],
};
</script>
<template>
  <span v-if="showCounter" data-toggle="tooltip" data-placement="bottom" :title="counterTooltip">
    <i class="far fa-eye mr-1"></i>
    {{ localeCount }}
  </span>
</template>
