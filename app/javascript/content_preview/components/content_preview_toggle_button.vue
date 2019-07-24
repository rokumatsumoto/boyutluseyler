<script>
import { mapActions, mapState } from 'vuex';

export default {
  name: 'ContentPreviewToggleButton',
  computed: {
    ...mapState(['activeContent', 'contents']),
    contentCount() {
      return this.contents.length;
    },
  },
  mounted() {},
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
      <button class="btn-sm btn-main" @click="changeContent">
        {{ toggleButtonText() }}
      </button>
    </div>
    <div v-else-if="contentCount > 2">
      <button
        v-for="(content, i) in contents"
        :key="i"
        class="btn-sm btn-main float-left"
        @click="changeContent(content)"
      >
        {{ toggleButtonText(content.toggleButtonText) }}
      </button>
    </div>
  </div>
</template>
