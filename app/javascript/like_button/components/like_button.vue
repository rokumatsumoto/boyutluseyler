<script>
import { mapActions, mapState } from 'vuex';

export default {
  name: 'LikeButton',
  props: {
    likeCssClass: {
      type: String,
      required: true,
    },
    unlikeCssClass: {
      type: String,
      required: true,
    },
    likeText: {
      type: String,
      required: true,
    },
    unlikeText: {
      type: String,
      required: true,
    },
    likedStatus: {
      type: Boolean,
      required: true,
    },
    endpoint: {
      type: String,
      required: true,
    },
  },
  computed: {
    ...mapState(['liked']),
    buttonText() {
      return this.liked ? this.unlikeText : this.likeText;
    },
    buttonCssClass() {
      return this.liked ? this.unlikeCssClass : this.likeCssClass;
    },
  },
  created() {
    this.setLiked(this.likedStatus);
  },
  methods: {
    ...mapActions(['createNewLike', 'deleteLike', 'setLiked']),
    actionButtonClicked() {
      if (this.liked) {
        return this.deleteLike({ endpoint: this.endpoint });
      }

      return this.createNewLike({ endpoint: this.endpoint });
    },
  },
};
</script>

<template>
  <div>
    <button :class="buttonCssClass" @click="actionButtonClicked">
      <span>
        <i class="fas fa-lg fa-heart"></i>
      </span>
      <span class="btn-inner--text">{{ buttonText }}</span>
    </button>
  </div>
</template>
