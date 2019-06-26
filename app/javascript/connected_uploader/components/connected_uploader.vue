<script>
import { mapActions, mapState } from 'vuex';
import 'blueimp-file-upload/js/jquery.fileupload';
import DraggableFileList from './draggable_file_list.vue';

export default {
  name: 'ConnectedUploader',
  components: { DraggableFileList },
  props: {
    accept: {
      type: String,
      required: true,
    },
    addButtonText: {
      type: String,
      required: true,
    },
    removeButtonText: {
      type: String,
      required: true,
    },
    files: {
      type: Array,
      default: () => [],
      required: false,
    },
    directUrl: {
      type: String,
      required: true,
    },
    uploaderUrl: {
      type: String,
      required: true,
    },
    createUrl: {
      type: String,
      required: true,
    },
    inputName: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      fileCount: 0,
    };
  },
  computed: {
    ...mapState(['hovering']),
  },
  mounted() {
    const $fileUploadInput = $(this.$refs.fileUploadInput);
    this.$nextTick(() => {
      $fileUploadInput.fileupload({
        url: this.directUrl,
        dataType: 'XML',
        paramName: 'file',
        add: this.handleUploadAdd,
        dropZone: this,
      });
      $fileUploadInput.on('fileuploadprogress', this.handleUploadProgress);
      $fileUploadInput.on('fileuploaddone', this.handleUploadDone);
      $fileUploadInput.on('dragover', this.handleDragOver);
      $fileUploadInput.on('dragleave', this.handleDragLeave);
      $(document).bind('drop dragover', this.handleDocumentDropAndDragOver);
    });
  },
  destroyed() {
    $(this.$refs.fileUploadInput).fileupload('destroy');
    $(document).unbind('drop dragover', this.handleDocumentDropAndDragOver);
  },
  methods: {
    ...mapActions([
      'dragOver',
      'dragLeave',
      'addFile',
      'fetchPresignedPost',
      'setFileStatus',
      'createNewFileResource',
    ]),
    handleUploadAdd(e, data) {
      data.uniqueId = `new ${(this.fileCount += 1)}`;
      const file = data.files[0];
      this.addFile({
        uniqueId: data.uniqueId,
        filename: file.name,
        size: file.size,
      });

      const invalidCharactersArr = ['&', '>', '<'];
      const checker = value => [file.name].some(element => element.includes(value));
      const invalidCharacters = invalidCharactersArr.filter(checker);
      if (invalidCharacters.length > 0) {
        return this.setFileStatus({
          actionName: 'ERROR_FILE',
          uniqueId: data.uniqueId,
          error: `Geçersiz karakter ${invalidCharacters.map(c => `"${c}"`).join(' ')}`,
        });
      }

      this.fetchPresignedPost({
        uploaderUrl: this.uploaderUrl,
        uniqueId: data.uniqueId,
        data,
        file,
      });
    },
    handleUploadProgress(e, data) {
      this.setFileStatus({
        actionName: 'PROGRESS_FILE',
        uniqueId: data.uniqueId,
        loaded: data.loaded,
      });
    },
    handleUploadDone(e, data) {
      console.log('upload done');
      this.createNewFileResource({
        createUrl: this.createUrl,
        key: data.result.getElementsByTagName('Key')[0].innerHTML,
        uniqueId: data.uniqueId,
      });
    },
    handleDragOver() {
      this.dragOver();
    },
    handleDragLeave() {
      this.dragLeave();
    },
    handleDocumentDropAndDragOver(e) {
      e.target.type !== 'file' && e.preventDefault();
    },
    decrementFileCount() {
      this.fileCount -= 1;
    },
  },
};
</script>

<template>
  <div>
    <div
      role="button"
      class="btn btn-grey btn-drop"
      :class="{ 'btn-drop--over': hovering }"
      tabindex="0"
    >
      <p>{{ addButtonText }}</p>
      <input
        ref="fileUploadInput"
        class="btn-drop--input"
        type="file"
        multiple
        :accept="accept"
        tabindex="-1"
      />
    </div>
    <draggable-file-list
      :input-name="inputName"
      :remove-button-text="removeButtonText"
      @on-remove="decrementFileCount"
    />
  </div>
</template>
