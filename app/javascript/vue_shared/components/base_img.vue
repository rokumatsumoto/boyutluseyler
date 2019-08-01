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
    backgroundColor: {
      type: String,
      default: '#b4b4b4',
      required: false,
    },
    defaultSrc: {
      type: String,
      default: '',
      required: false,
    },
  },
  data() {
    return {
      imageError: false,
    };
  },
  computed: {
    style() {
      const style = {
        'background-color': this.backgroundColor,
      };
      return style;
    },
    source() {
      return this.imageError ? this.defaultSrc : this.src;
    },
  },
};
</script>
<template>
  <img
    :style="style"
    :loading="loading"
    :src="source"
    :alt="alt"
    :class="cssClass"
    @error="imageError = true"
  />
</template>
