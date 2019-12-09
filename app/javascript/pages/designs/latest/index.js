import Pagy from 'pagy';

document.addEventListener('turbolinks:load', () => {
  Pagy.init();
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');
