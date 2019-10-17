<script>
import { mapActions, mapState } from 'vuex';
export default {
  name: 'DownloadButton',
  props: {
    cssClass: {
      type: String,
      required: true,
    },
    text: {
      type: String,
      required: true,
    },
    downloadingText: {
      type: String,
      required: true,
    },
    recordId: {
      type: String,
      required: true,
    },
    endpoint: {
      type: String,
      required: true,
    }
  },
  computed: {
    ...mapState(['isDownloading']),
    buttonText() {
      return this.isDownloading ? this.downloadingText : this.text;
    },
    iconCssClass() {
      return this.isDownloading ? 'fa-circle-notch fa-spin' : 'fa-cloud-download-alt';
    }
  },
  channels: {
    DownloadChannel: {
      connected() {
        console.log('I am connected.');
      },
			rejected() {},
			received(data) {
        if (data.url) {
          this.$cable.unsubscribe('DownloadChannel');
          window.location = data.url;

          this.setDownloading(false);
        }
      },
			disconnected() {
        console.log('I am disconnected.');
      },
    }
  },
  methods: {
    ...mapActions([
      'fetchDownloadUrl',
      'setDownloading',
    ]),
    // Temporary fix for now (Code smell)
    addDownloadChannel() {
      const downloadChannel = Object.entries(this.$options.channels)[0];
      this.$cable._addChannel(downloadChannel[0], downloadChannel[1], this);
    },
    download() {
      // TESTING PURPOSE
      // https://github.com/mclintprojects/actioncable-vue/issues/4
      // this.addDownloadChannel();
      // this.$cable.subscribe({ channel: 'DownloadChannel', id: this.recordId });

      // const vm = this;
      // setTimeout(function(){
      //   vm.$cable.unsubscribe('DownloadChannel');
      //  }, 1000);
      this.fetchDownloadUrl({
        vm: this,
        endpoint: this.endpoint,
        recordId: this.recordId,
      });
    }
  }
  // mounted() {
  //   this.$cable.subscribe({ channel: 'DownloadChannel', id: this.recordId });
  // }
}
</script>

<template>
  <div>
    <button ref="downloadButton" :class="cssClass" @click="download" :disabled="isDownloading">
      <span><i class="fas fa-lg" :class="iconCssClass"></i></span>
      <span class="btn-inner--text">{{ buttonText }}</span>
    </button>
  </div>
</template>
