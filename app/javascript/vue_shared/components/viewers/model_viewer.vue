<script>
import { ModelStl } from 'vue-3d-model';
import eventHub from './event_hub';

export default {
  name: 'ModelViewer',
  components: { ModelStl },
  data() {
    return {
      resized: false,
    }
  },
  mounted() {
    eventHub.$on('show', this.resize)
  },
  beforeDestroy() {
    eventHub.$off('show', this.resize)
  },
  methods: {
    resize() {
      if (this.resized === false){
        this.$refs.model.onResize();
        this.resized = true;
      }
    },
  },
};
</script>
<template>
  <model-stl ref="model"
    src="models/bowser_low_poly_flowalistik.STL"
  />
</template>
