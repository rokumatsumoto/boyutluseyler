<script>
import { mapActions, mapState } from 'vuex';
import Draggable from 'vuedraggable';
import ConnectedUploaderFileListItem from './connected_uploader_file_list_item.vue';

export default {
  name: 'ConnectedUploaderFileList',
  components: {
    ConnectedUploaderFileListItem,
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
      type: Object,
      required: true,
    },
    dataType: {
      type: String,
      required: true,
    }
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
    if (this.originFiles.data && this.originFiles.data.length > 0) {
      this.addOriginFiles({
        originFiles: this.originFiles,
        dataType: this.dataType,
      });
    }
  },
  methods: {
    ...mapActions(['removeFile', 'updateFileList', 'addFile', 'addOriginFiles']),
  },
};
</script>
<template>
  <div v-if="hasFiles">
    <draggable v-model="draggableList" draggable=".js-connected-uploader-file-list-item" animation=200>
      <connected-uploader-file-list-item
        v-for="file in files"
        :key="file.uniqueId"
        :file="file"
        :input-name="inputName"
        :remove-button-text="removeButtonText"
        @on-remove="removeFile"
      />
    </draggable>
  </div>
  <div v-else>
    <input type="hidden" :name="inputName"/>
  </div>
</template>
