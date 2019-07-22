<script>
import { mapActions, mapState } from 'vuex';
import BaseImg from 'vue_shared/components/base_img.vue';
import ModelViewer from 'vue_shared/components/viewers/model_viewer.vue';
import eventHub from 'vue_shared/components/viewers/event_hub';

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
    triggerViewer() {
      if (this.activeContent.contentType === 'model') {
        eventHub.$emit('show');
      }
    },
    showContent() {
      const show = this.content.dataType === this.activeContent.dataType;
      if (show) {
        this.triggerViewer();
      }
      return show;
    },
  },
};
</script>
<template>
  <div v-show="showContent()">
    <div :ref="content.dataType" class="pic" :class="`pic--${content.dataType}`">
      {{ content.dataType }}
      <div class="pic-main">
        <keep-alive>
          <component :is="viewer" />
        </keep-alive>
      </div>
    </div>
  </div>
</template>
