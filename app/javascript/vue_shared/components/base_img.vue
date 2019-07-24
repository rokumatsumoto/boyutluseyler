<script>
export default {
  name: 'BaseImg',
  props: {
    loading: {
      type: String,
      default: 'auto',
      required: false,
    },
    alt: {
      type: String,
      default: '',
      required: false,
    },
    src: {
      type: String,
      required: true,
    },
    cssClass: {
      type: String,
      default: '',
      required: false,
    },
  },
};
</script>
<template>
  <img :loading="loading" :alt="alt" :src="src" :class="cssClass" />
</template>
