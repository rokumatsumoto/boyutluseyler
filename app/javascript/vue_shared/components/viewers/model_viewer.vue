<script>
import { ModelStl, ModelObj } from 'vue-3d-model';
import getFileExtension from 'lib/utils/file_utils';
import eventHub from './event_hub';

export default {
  name: 'ModelViewer',
  components: { ModelStl, ModelObj },
  props: {
    src: {
      type: String,
      required: true,
    },
  },
  computed: {
    fileExtension() {
      return getFileExtension(this.src).toLowerCase();
    },
    modelProps() {
      switch (this.fileExtension) {
        case 'stl':
          return {
            src: this.src,
          };
        case 'obj':
          return {
            src: this.src,
          };
        default:
          return {};
      };
    },
    model() {
      switch (this.fileExtension) {
        case 'stl':
          return ModelStl;
        case 'obj':
          return ModelObj;
        default:
          return null;
      }
    },
  },
  created() {
    eventHub.$on('show', this.resize); // eventHub.$once
  },
  beforeDestroy() {
    eventHub.$off('show', this.resize);
  },
  methods: {
    resize() {
      if (this.$refs.model !== undefined) {
        this.$refs.model.onResize();
      }
    },
  },
};
</script>
<template>
  <component :is="model" ref="model" v-bind="modelProps" />
</template>
