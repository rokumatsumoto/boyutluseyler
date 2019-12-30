<script>
// TODO: avatar_cropper.vue
import Cropper from 'cropperjs';
import 'blueimp-file-upload/js/jquery.fileupload';
import 'blueimp-canvas-to-blob/js/canvas-to-blob.min';
import { mapActions, mapState } from 'vuex';
import { uuidV4 } from 'lib/utils/number_utils';
import getFileExtension from 'lib/utils/file_utils';
import { MIN_FILE_SIZE, MAX_FILE_SIZE } from '../constants';
import { INVALID_CHARACTERS } from '../../connected_uploader/constants';

const mime = require('mime/lite');

export default {
  name: 'AvatarUploader',
  props: {
    src: {
      type: String,
      required: true,
    },
    inputName: {
      type: String,
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
    cropperOptions: {
      type: Object,
      default() {
        return {
          aspectRatio: 1,
          autoCropArea: 1,
          viewMode: 1,
          movable: false,
          zoomable: false,
        };
      },
    },
    outputOptions: {
      type: Object,
      required: false,
      default() {
        return {};
      },
    },
    outputMime: {
      type: String,
      default: 'image/jpeg',
    },
    outputQuality: {
      type: Number,
      default: 0.9,
    },
    mimes: {
      type: String,
      default: 'image/png, image/gif, image/jpeg',
    },
  },
  data() {
    return {
      cropper: undefined,
      dataURI: undefined,
      filename: undefined,
      mimeType: undefined,
      data: undefined,
    };
  },
  computed: {
    ...mapState(['fileStatus', 'imageSrc', 'hiddenImageSrc']),
  },
  created() {
    this.setImageSrc(this.src);
    this.setHiddenImageSrc(this.src);
  },
  mounted() {
    const $fileInput = $(this.$refs.input);
    this.$refs.button.addEventListener('click', this.pickImage);
    this.$nextTick(() => {
      $fileInput.fileupload({
        url: this.directUrl,
        dataType: 'XML',
        paramName: 'file',
        add: this.handleUploadAdd,
        dropZone: this,
        replaceFileInput: false,
      });
      $fileInput.on('fileuploaddone', this.handleUploadDone);
      $(document).bind('drop dragover', this.handleDocumentDropAndDragOver);
    });
  },
  destroyed() {
    $(this.$refs.input).fileupload('destroy');
    $(document).unbind('drop dragover', this.handleDocumentDropAndDragOver);
  },
  methods: {
    ...mapActions(['fetchPresignedPost', 'setFileStatus', 'setImageSrc', 'setHiddenImageSrc']),
    destroyCropper() {
      this.cropper.destroy();
      this.$refs.input.value = '';
      this.dataURI = undefined;
      this.filename = undefined;
      this.mimeType = undefined;
    },
    cancelUpload() {
      this.destroyCropper();
      const jqXHR = this.data.submit();
      jqXHR.abort();
      this.data = undefined;
    },
    submit() {
      this.$emit('submit');
      this.uploadImage();
      this.destroyCropper();
    },
    pickImage(e) {
      this.$refs.input.click();
      e.preventDefault();
      e.stopPropagation();
    },
    createCropper() {
      this.cropper = new Cropper(this.$refs.cropImg, this.cropperOptions);
    },
    handleUploadAdd(e, data) {
      const fileInput = this.$refs.input;
      this.data = data;
      if (fileInput.files != null && fileInput.files[0] != null) {
        const reader = new FileReader();
        reader.onload = event => {
          this.dataURI = event.target.result;
        };
        reader.readAsDataURL(fileInput.files[0]);
        this.filename = fileInput.files[0].name || 'unknown';
        this.mimeType = fileInput.files[0].type;
        this.$emit('changed', fileInput.files[0], reader);
      }
    },
    handleUploadDone(e, data) {
      this.setFileStatus('Yüklendi');
      this.setImageSrc(`${this.directUrl}/${data.result.getElementsByTagName('Key')[0].innerHTML}`);
      this.setHiddenImageSrc(data.result.getElementsByTagName('Key')[0].innerHTML);
    },
    handleDocumentDropAndDragOver(e) {
      e.target.type !== 'file' && e.preventDefault();
    },
    uploadImage() {
      const vm = this;
      this.cropper.getCroppedCanvas(this.outputOptions).toBlob(
        blob => {
          const filename = `${uuidV4()}.${mime.getExtension(this.outputMime)}`;
          Object.assign(blob, { name: filename });
          vm.data.files = [blob];

          return this.fetchPresignedPost({
            uploaderUrl: this.uploaderUrl,
            data: vm.data,
            file: blob,
          });
        },
        this.outputMime,
        this.outputQuality,
      );
    },
  },
};
</script>
<template>
  <div class="d-flex flex-sm-row flex-column">
    <img ref="img" class="avatar-circle s160" :src="imageSrc" />
    <div class="avatar-uploader">
      <div v-if="dataURI" class="avatar-cropper-overlay">
        <div class="avatar-cropper-mark">
          <a class="avatar-cropper-close" href="javascript:;" @click="cancelUpload">&times;</a>
        </div>
        <div class="avatar-cropper-container">
          <div class="avatar-cropper-image-container">
            <img ref="cropImg" :src="dataURI" alt @load.stop="createCropper" />
          </div>
          <div class="avatar-cropper-footer">
            <button class="avatar-cropper-btn" @click.stop.prevent="cancelUpload">İptal</button>
            <button class="avatar-cropper-btn" @click.stop.prevent="submit">Kaydet</button>
          </div>
        </div>
      </div>
      <input ref="input" :accept="mimes" class="avatar-cropper-img-input" type="file" />
    </div>
    <div class="d-flex flex-column form-group-2">
      <label class="form-control-label">Yeni profil resmi yükle</label>
      <div class="d-inline-flex align-items-center">
        <button ref="button" class="btn btn-primary btn-sm">Dosya seçin...</button>
        <span class="ml-2 text-sm">{{ fileStatus }}</span>
      </div>
    </div>
    <input type="hidden" :name="inputName" :value="hiddenImageSrc" />
  </div>
</template>
