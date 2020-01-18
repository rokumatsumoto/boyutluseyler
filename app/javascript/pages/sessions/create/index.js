import UsernameValidator from 'pages/shared/username_validator';
import OAuthRememberMe from '../oauth_remember_me';

document.addEventListener('turbolinks:load', () => {
  new UsernameValidator(); // eslint-disable-line no-new

  new OAuthRememberMe({
    container: $('.omniauth-container'),
  }).bindEvents();
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');

