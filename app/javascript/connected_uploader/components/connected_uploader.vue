<script>
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
    },
    watch: {
    },
    methods: {
    },
  };
</script>

<template>
<div>
  <div role="button" class="btn btn-light btn-drop">
    <p>{{ addButtonText }}</p>
    <input type="file" multiple :accept="accept">
  </div>
  <div>

  </div>
</div>
</template>
