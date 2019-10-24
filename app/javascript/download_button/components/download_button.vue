<script>
import Noty from 'noty';
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
          window.location = data.url;
        } else {
          new Noty({
            type: 'error',
            layout: 'top',
            timeout: 4000,
            text: data.message,
          }).show();
        }
        this.$cable.unsubscribe('DownloadChannel');
        this.setDownloading(false);
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
    download() {
      this.fetchDownloadUrl({
        vm: this,
        endpoint: this.endpoint,
        recordId: this.recordId,
      });
    }
  }
}
</script>

<template>
  <div>
    <button :class="cssClass" @click="download" :disabled="isDownloading">
      <span><i class="fas fa-lg" :class="iconCssClass"></i></span>
      <span class="btn-inner--text">{{ buttonText }}</span>
    </button>
  </div>
</template>
