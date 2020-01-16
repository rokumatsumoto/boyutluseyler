import OAuthRememberMe from '../oauth_remember_me';

document.addEventListener('turbolinks:load', () => {
  new OAuthRememberMe({
    container: $('.omniauth-container'),
  }).bindEvents();
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');

