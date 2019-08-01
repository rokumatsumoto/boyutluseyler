<script>
import { mapState, mapGetters, mapActions } from 'vuex';

export default {
  name: 'ContentPreviewToggleButton',
  props: {
    cssClass: {
      type: String,
      required: true,
    }
  },
  computed: {
    ...mapState(['activeContent', 'contents']),
    ...mapGetters(['contentCount']),
  },
  methods: {
    ...mapActions(['setActiveContent']),
    toggleButtonText(text) {
      let name = '';
      if (this.contentCount === 2) {
        name = this.contents.find(c => c !== this.activeContent).toggleButtonText;
      } else {
        name = text;
      }
      return name;
    },
    changeContent(content) {
      let newContent = this.activeContent;
      if (this.contentCount === 2) {
        newContent = this.contents.find(c => c !== this.activeContent);
      } else {
        newContent = content;
      }
      this.setActiveContent(newContent);
    },
  },
};
</script>
<template>
  <div>
    <div v-if="contentCount === 2">
      <button :class="cssClass" @click="changeContent">
        {{ toggleButtonText() }}
      </button>
    </div>
    <div v-else-if="contentCount > 2">
      <button
        v-for="(content, i) in contents"
        :key="i"
        :class="cssClass"
        style="margin-right:2px;"
        @click="changeContent(content)"
      >
        {{ toggleButtonText(content.toggleButtonText) }}
      </button>
    </div>
  </div>
</template>
