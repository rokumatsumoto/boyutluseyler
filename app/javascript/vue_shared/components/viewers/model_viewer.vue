<script>
import { ModelStl } from 'vue-3d-model';

export default {
  name: 'ModelViewer',
  components: { ModelStl },
};
</script>
<template>
  <model-stl
    :width="300"
    :height="300"
    src="models/bowser_low_poly_flowalistik.STL"
  />
</template>
