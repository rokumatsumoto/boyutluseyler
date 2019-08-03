<script>
import { numberToHumanSize } from 'lib/utils/number_utils';
import sanitize from 'sanitize-html';

export default {
  name: 'ConnectedUploaderFileListItem',
  props: {
    file: {
      type: Object,
      required: true,
    },
    inputName: {
      type: String,
      required: true,
    },
    removeButtonText: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      anchoredFileName: `<a target='_blank' href='${this.file.url}' class='up-link' rel='noopener'>${this.file.filename}</a>`
    };
  },
  computed: {
    isLoading() {
      return this.file.loading;
    },
    hasError() {
      return this.file.error !== null && this.file.error !== ''
    },
    iconClass() {
      return this.isLoading ? 'up-icon--loading' : 'up-icon--file';
    },
    filename() {
      if (this.hasError) {
        return this.file.error;
      }
      if (this.file.url) {
        return sanitize(this.anchoredFileName, {
          allowedTags: [ 'a' ],
          allowedAttributes: {
            'a': [ 'target', 'href', 'rel', 'class' ]
          },
        });
      }
      return this.file.filename;
    },
    size() {
      if (this.hasError) {
        return this.file.filename;
      }
      return numberToHumanSize(this.file.size);
    },
    progress() {
      const progress = parseFloat(this.file.loaded / this.file.size);
      const isNotNumber = value => Number.isNaN(Number(value));
      if (isNotNumber(progress)) {
        return 0;
      }
      return 100 * progress;
    },
  },
};
</script>
<template>
  <div class="up-container" :class="{ 'js-connected-uploader-file-list-item': !isLoading }">
    <div class="up" :class="{ 'up--error': hasError, 'up--draggable': !isLoading }">
      <div v-if="!hasError"
        class="up-progress"
        role="bar"
        aria-valuemin="0"
        aria-valuemax="100"
        :aria-valuenow="progress"
        :style="{ width: progress + '%' }"
      ></div>
      <div class="up-content">
        <div class="up-image">
          <div :class="iconClass"></div>
        </div>
        <div class="up-text">
           <!-- eslint-disable-next-line vue/no-v-html -->
          <div class="up-title" v-html="filename"></div>
          <div class="up-size">{{ size }}</div>
        </div>
      </div>
      <div v-if="!isLoading" class="up-actions">
        <button type="button" class="btn btn--clear" :title="removeButtonText" @click="$emit('on-remove', file.uniqueId)">
          ×
        </button>
      </div>
      <input type="hidden" :name="inputName" :value="file.id" />
    </div>
  </div>
</template>
