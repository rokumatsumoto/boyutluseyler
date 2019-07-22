<script>
import { mapActions, mapState } from 'vuex';
import BaseImg from 'vue_shared/components/base_img.vue';
import ModelViewer from 'vue_shared/components/viewers/model_viewer.vue';

export default {
  name: 'ContentPreview',
  components: {
    BaseImg,
    ModelViewer,
  },
  props: {
    dataType: {
      type: String,
      required: true,
    },
    contentType: {
      type: String,
      required: true,
    },
    toggleButtonText: {
      type: String,
      default: 'Toggle',
      required: false,
    },
    active: {
      type: Boolean,
      default: false,
      required: false,
    },
  },
  data() {
    return {
      content: {
        dataType: this.dataType,
        contentType: this.contentType,
        toggleButtonText: this.toggleButtonText,
        active: this.active,
      },
    };
  },
  computed: {
    ...mapState(['activeContent', 'contents']),
    viewer() {
      switch (this.content.contentType) {
        case 'image':
          return BaseImg;
        case 'model':
          return ModelViewer;
        default:
          return null;
      }
    },
  },
  mounted() {
    this.registerContent(this.content);
  },
  methods: {
    ...mapActions(['registerContent']),
    showContent() {
      return this.content.dataType === this.activeContent.dataType || this.contents.length === 1;
    },
  },
};
</script>
<template>
  <div v-show="showContent()">
    <div :ref="content.dataType" class="pic" :class="`pic--${content.dataType}`">
      {{ content.dataType }}
      <div class="pic-main">
        <component :is="viewer" />
      </div>
    </div>
  </div>
</template>
