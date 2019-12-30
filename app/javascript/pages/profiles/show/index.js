import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import UsernameValidator from 'pages/shared/username_validator';
import AvatarUploader from 'avatar_uploader/components/avatar_uploader.vue';
import createAvatarUploaderStore from 'avatar_uploader/store';

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  new UsernameValidator(); // eslint-disable-line no-new

  const $avatarUploaders = document.getElementsByClassName('js-avatar-uploader');
  if ($avatarUploaders.length > 0) {
    Array.from($avatarUploaders).forEach($avatarUploader => {
      const app = new Vue({
        el: $avatarUploader,
        store: createAvatarUploaderStore(),
        components: { AvatarUploader },
      });
    });
  }
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');


