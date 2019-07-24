<script>
import { mapActions, mapState } from 'vuex';
import BaseImg from 'vue_shared/components/base_img.vue';
import ModelViewer from 'vue_shared/components/viewers/model_viewer.vue';
import eventHub from 'vue_shared/components/viewers/event_hub';
import ThumbnailList from './thumbnail_list.vue';

export default {
  name: 'ContentPreview',
  components: {
    ThumbnailList,
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
    imgAltTag: {
      type: String,
      default: '',
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
      contentFiles: [
        {
          url: 'http://192.168.2.3:3000/images/sarge_bust_bw_1_large.jpg',
          imageUrl: 'http://192.168.2.3:3000/images/sarge_bust_bw_1_thumb.jpg',
          contentType: 'image/jpeg',
        },
        {
          url: 'http://192.168.2.3:3000/images/sarge_bust_01_large.jpg',
          imageUrl: 'http://192.168.2.3:3000/images/sarge_bust_01_thumb.jpg',
          contentType: 'image/jpeg',
        },
        {
          url: 'http://192.168.2.3:3000/images/sarge_bust_02_large.jpg',
          imageUrl: 'http://192.168.2.3:3000/images/sarge_bust_02_thumb.jpg',
          contentType: 'image/jpeg',
        },
        {
          url: 'http://192.168.2.3:3000/images/sarge_bust_03_large.jpg',
          imageUrl: 'http://192.168.2.3:3000/images/sarge_bust_03_thumb.jpg',
          contentType: 'image/jpeg',
        },
      ],
      contentFile: {},
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
    viewerProps() {
      switch (this.viewer) {
        case BaseImg:
          return {
            loading: 'lazy',
            alt: this.imgAltTag,
            src: this.contentFile.url ? this.contentFile.url : this.contentFiles[0].url,
            cssClass: 'thumb',
          };
        case ModelViewer:
          return {
            src: this.contentFile.url ? this.contentFile.url : this.contentFiles[0].url,
          };
        default:
          return {};
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
    showContentFile(file) {
      this.contentFile = file;
    },
  },
};
</script>
<template>
  <div v-show="showContent()">
    <div :ref="content.dataType" class="pic" :class="`pic--${content.dataType}`">
      <div class="pic-main">
        <keep-alive>
          <component :is="viewer" v-bind="viewerProps" />
        </keep-alive>
      </div>
      <div class="pic-minis">
        <thumbnail-list
          :list="contentFiles"
          img-loading="lazy"
          :img-alt-tag="imgAltTag"
          @img-update="showContentFile"
        />
      </div>
    </div>
  </div>
</template>
