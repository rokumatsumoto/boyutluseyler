<script>
export default {
  name: 'DraggableFileListItem',
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
  computed: {
    isLoading() {
      return this.file.loading;
    },
    hasError() {
      return this.file.error;
    },
    iconClass() {
      return this.isLoading ? 'up-icon--loading' : 'up-icon--file';
    },
    filename() {
      if (this.hasError) {
        return this.file.error;
      }
      return this.file.filename;
    },
    size() {
      if (this.hasError) {
        return this.file.filename;
      }
      return this.file.size;
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
  <div class="up-container">
    <div class="up up--draggable" :class="{ 'up--error': hasError }">
      <div
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
          <div class="up-title">{{ filename }}</div>
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
