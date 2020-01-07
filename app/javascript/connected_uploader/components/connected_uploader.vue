<script>
import { mapActions, mapState } from 'vuex';
import { numberToHumanSize } from 'lib/utils/number_utils';
import getFileExtension from 'lib/utils/file_utils';
import { INVALID_CHARACTERS, MIN_FILE_SIZE, MAX_FILE_SIZE } from '../constants';
import 'blueimp-file-upload/js/jquery.fileupload';
import ConnectedUploaderFileList from './connected_uploader_file_list.vue';

export default {
  name: 'ConnectedUploader',
  components: { ConnectedUploaderFileList },
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
      type: Object,
      required: true,
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
    dataType: {
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

      if (this.fileHasInvalidSize(file, data)) return true;
      if (this.fileHasInvalidCharacters(file, data)) return true;
      if (this.fileTypeInvalid(file, data)) return true;

      return this.fetchPresignedPost({
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
      this.createNewFileResource({
        createUrl: this.createUrl,
        key: data.result.getElementsByTagName('Key')[0].innerHTML,
        dataType: this.dataType,
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
    fileTypeInvalid(file, data) {
      const fileExtension = file.type === '' ? getFileExtension(file.name) : file.type;
      const acceptArr = this.accept.split(',').map(a => a.slice(1));
      const fileTypeChecker = value => [fileExtension].some(element => element.includes(value));
      const acceptType = acceptArr.filter(fileTypeChecker);
      if (acceptType.length === 0) {
        this.setFileStatus({
          actionName: 'ERROR_FILE',
          uniqueId: data.uniqueId,
          error: `Dosya geçersiz, izin verilen dosya türleri ${acceptArr.join(', ')}`,
        });
        return true;
      }
      return false;
    },
    fileHasInvalidCharacters(file, data) {
      let errorMessage = '';
      if (file.name.trim() === '' || file.name.trim().startsWith('.')) {
        errorMessage = 'Dosya adı boş olamaz';
      } else {
        const invalidCharacterChecker = value =>
          [file.name].some(element => element.includes(value));
        const invalidCharacters = INVALID_CHARACTERS.filter(invalidCharacterChecker);
        if (invalidCharacters.length > 0) {
          errorMessage = `Geçersiz karakter ${invalidCharacters.map(c => `"${c}"`).join(' ')}`;
        }
      }

      if (errorMessage !== '') {
        this.setFileStatus({
          actionName: 'ERROR_FILE',
          uniqueId: data.uniqueId,
          error: errorMessage,
        });
        return true;
      }
      return false;
    },
    fileHasInvalidSize(file, data) {
      if (file.size && file.size >= MIN_FILE_SIZE && file.size < MAX_FILE_SIZE) {
        return false;
      }
      this.setFileStatus({
        actionName: 'ERROR_FILE',
        uniqueId: data.uniqueId,
        error: `Dosya (${numberToHumanSize(file.size)}) geçersiz, izin verilen
          dosya boyutu ${numberToHumanSize(MIN_FILE_SIZE)} -
          ${numberToHumanSize(MAX_FILE_SIZE)}`,
      });
      return true;
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
    <connected-uploader-file-list
      :input-name="inputName"
      :remove-button-text="removeButtonText"
      :origin-files="files"
      :data-type="dataType"
    />
  </div>
</template>
