<script>
import BaseImg from 'vue_shared/components/base_img.vue';

export default {
  name: 'ThumbnailList',
  components: {
    BaseImg,
  },
  props: {
    list: {
      type: Array,
      required: true,
      validator: (prop) => [
        'url',
        'imageUrl',
        ].every( e => Object.keys(prop[0]).includes(e))
    },
    imgLoading: {
      type: String,
      default: 'auto',
      required: false,
    },
    imgAltTag: {
      type: String,
      default: '',
      required: false,
    },
  },
};
</script>
<template>
  <div style="width: 100%;">
    <a
      v-for="(item, i) in list"
      :key="i"
      class="thumb"
      :href="item.url"
      target="_blank"
      rel="noopener"
      @click.prevent="$emit('img-update', item)"
    >
      <base-img :loading="imgLoading" :alt="imgAltTag" :src="item.imageUrl" />
    </a>
</div>
</template>
