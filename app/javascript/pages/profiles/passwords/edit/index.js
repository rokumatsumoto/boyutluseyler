import ChangePasswordValidator from './change_password_validator'

document.addEventListener('turbolinks:load', () => {
  new ChangePasswordValidator(); // eslint-disable-line no-new
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');


