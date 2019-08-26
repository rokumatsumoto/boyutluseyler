import UsernameValidator from 'pages/shared/username_validator'
import ChangePasswordValidator from './change_password_validator'

document.addEventListener('turbolinks:load', () => {
  new UsernameValidator(); // eslint-disable-line no-new
  new ChangePasswordValidator(); // eslint-disable-line no-new
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');


