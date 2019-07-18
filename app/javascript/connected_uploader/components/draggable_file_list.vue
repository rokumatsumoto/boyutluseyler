<script>
import { mapActions, mapState } from 'vuex';
import Draggable from 'vuedraggable';
import DraggableFileListItem from './draggable_file_list_item.vue';

export default {
  name: 'DraggableFileList',
  components: {
    DraggableFileListItem,
    Draggable,
  },
  props: {
    inputName: {
      type: String,
      required: true,
    },
    removeButtonText: {
      type: String,
      required: true,
    },
    originFiles: {
      type: Array,
      default: () => [],
      required: false,
    },
  },
  computed: {
    ...mapState(['files']),
    hasFiles() {
      return this.files.length > 0;
    },
    draggableList: {
      get() {
        return this.files;
      },
      set(value) {
        this.updateFileList(value);
      },
    },
  },
  mounted() {
    if (this.originFiles.length > 0) {
      Array.from(this.originFiles).forEach((originFile) => {
        this.addFile({
          uniqueId: originFile.id,
          id: originFile.id,
          filename: originFile.filename,
          size: originFile.size,
          url: originFile.url,
          image: originFile.image_url,
        });
      });
    }
  },
  methods: {
    ...mapActions(['removeFile', 'updateFileList', 'addFile']),
    handleRemove(uniqueId) {
      this.removeFile(uniqueId);
      this.$emit('on-remove');
    },
  },
};
</script>
<template>
  <div v-if="hasFiles">
    <draggable v-model="draggableList" draggable=".js-draggable-file-list-item" animation=200>
      <draggable-file-list-item
        v-for="file in files"
        :key="file.uniqueId"
        :file="file"
        :input-name="inputName"
        :remove-button-text="removeButtonText"
        @on-remove="handleRemove"
      />
    </draggable>
  </div>
</template>
