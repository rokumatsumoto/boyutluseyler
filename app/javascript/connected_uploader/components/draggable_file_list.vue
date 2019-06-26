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
  },
  computed: {
    ...mapState(['files']),
    hasFiles() {
      return this.files.length > 0;
    },
    myList: {
      get() {
        return this.files;
      },
      set(value) {
        this.updateFileList(value);
      },
    },
  },
  methods: {
    ...mapActions(['removeFile', 'updateFileList']),
    handleRemove(uniqueId) {
      this.removeFile(uniqueId);
      this.$emit('on-remove');
    },
  },
};
</script>
<template>
  <div v-if="hasFiles">
    <draggable v-model="myList" animation=200>
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
