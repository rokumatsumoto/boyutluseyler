<script>
import { mapActions } from 'vuex';
import 'blueimp-file-upload/js/jquery.fileupload'

  export default {
    name: 'ConnectedUploader',
    components: {
    },
    directives: {
    },
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
      }
    },
    data() {
      return {
      };
    },
    computed: {
      hovering() {
        return this.$store.state.hovering;
      }
    },
    watch: {
    },
    mounted() {
      const $fileUploadInput = $(this.$refs.fileUploadInput);
      this.$nextTick(() => {
        $fileUploadInput.fileupload({
            url: this.directUrl,
            dataType: "XML",
            paramName: "file",
            add: this.handleUploadAdd,
            dropZone: this
        });
        $fileUploadInput.on("dragover", this.handleDragOver);
        $fileUploadInput.on("dragleave", this.handleDragLeave);
        $(document).bind('drop dragover', this.handleDocumentDropAndDragOver);
      })
    },
    destroyed() {
      $(this.$refs.fileUploadInput).fileupload("destroy");
      $(document).unbind("drop dragover", this.handleDocumentDropAndDragOver);
    },
    methods: {
      ...mapActions([
        'dragOver',
        'dragLeave',
      ]),
      handleUploadAdd(e, data) {
        console.log('add');
        // data.submit();
      },
      handleDragOver() {
        this.dragOver();
      },
      handleDragLeave() {
        this.dragLeave();
      },
      handleDocumentDropAndDragOver(e) {
        e.target.type !== 'file' && e.preventDefault()
      }
    },
  };
</script>

<template>
<div>
  <div role="button" class="btn btn-grey btn-drop" :class="{'btn-drop--over': hovering}" tabindex="0">
    <p>{{ addButtonText }}</p>
    <input ref="fileUploadInput" class="btn-drop--input" type="file" multiple :accept="accept" tabindex="-1">
  </div>
  <div>

  </div>
</div>
</template>
