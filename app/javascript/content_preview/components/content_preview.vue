<script>
import { mapState, mapGetters, mapActions } from 'vuex';
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
    fileExtensions: {
      type: Array,
      default: () => [],
      required: false,
    },
    files: {
      type: Object,
      required: true,
      // https://jsonapi.org/format/
      validator: prop => Object.keys(prop).includes('data'),
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
    defaultThumbUrl: {
      type: String,
      default: '',
      required: false,
    },
    imgBgColor: {
      type: String,
      default: '',
      required: false,
    },
    viewerCssClass: {
      type: String,
      default: '',
      required: false,
    },
  },
  data() {
    return {
      contentFile: {},
    };
  },
  computed: {
    ...mapState(['activeContent', 'contents']),
    ...mapGetters(['getContent']),
    content() {
      return this.getContent(this.dataType);
    },
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
            src: this.contentFile.url ? this.contentFile.url : this.content.files[0].url,
            cssClass: this.viewerCssClass,
            defaultSrc: this.defaultThumbUrl,
          };
        case ModelViewer:
          return {
            src: this.contentFile.url ? this.contentFile.url : this.content.files[0].url,
            cssClass: this.viewerCssClass,
          };
        default:
          return {};
      }
    },
  },
  created() {
    if (this.files.data && this.files.data.length > 0) {
      this.registerContent({
        dataType: this.dataType,
        contentType: this.contentType,
        fileExtensions: this.fileExtensions,
        files: this.files,
        toggleButtonText: this.toggleButtonText,
        active: this.active,
        imgAltTag: this.imgAltTag,
      });
    }
  },
  methods: {
    ...mapActions(['registerContent']),
    triggerViewer() {
      if (this.activeContent.contentType === 'model') eventHub.$emit('show');
    },
    showContent() {
      if (this.content === undefined) {
        return false;
      }

      const { active } = this.content;
      if (active) {
        this.triggerViewer();
      }
      return active;
    },
    showContentFile(file) {
      this.contentFile = file;
    },
  },
};
</script>
<template>
  <div v-show="showContent()">
    <div :ref="dataType" class="pic" :class="`pic--${dataType}`">
      <div class="pic-main">
        <keep-alive>
          <component :is="viewer" v-if="content" v-bind="viewerProps" />
        </keep-alive>
      </div>
      <div class="pic-minis">
        <thumbnail-list
          v-if="content"
          :list="content.files"
          img-loading="lazy"
          :img-alt-tag="imgAltTag"
          :default-img-src="defaultThumbUrl"
          :img-bg-color="imgBgColor"
          @img-update="showContentFile"
        />
      </div>
    </div>
  </div>
</template>
