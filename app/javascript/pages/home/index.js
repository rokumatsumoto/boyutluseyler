document.addEventListener('turbolinks:load', () => {
  function getStartedClick(event) {
    event.preventDefault();
    const scrollTo = document.getElementById('most-downloaded');
    const topPos = scrollTo.offsetTop - 100;

    $("html, body").animate({
      scrollTop: topPos
    }, 500);
  };

  const getStarted = document.getElementById('get-started-scroll');
  if (getStarted !== null) {
    getStarted.addEventListener('click', getStartedClick.bind(this), false);
  }
});

if (typeof Turbolinks === 'undefined' || Turbolinks === null) {
  location.reload;
}
Turbolinks.dispatch('turbolinks:load');


