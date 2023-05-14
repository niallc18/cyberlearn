//Reference:
//https://www.javascripting.com/view/turbolinks
//https://www.freecodecamp.org/news/refresh-the-page-in-javascript-js-reload-window-tutorial/
document.addEventListener('turbolinks:load', function() {
  if (window.location.href.indexOf("/assessments") > -1) {
    if (!sessionStorage.getItem('reloaded')) {
      sessionStorage.setItem('reloaded', true);
      window.location.reload();
    } else {
      sessionStorage.removeItem('reloaded');
    }
  }
});


