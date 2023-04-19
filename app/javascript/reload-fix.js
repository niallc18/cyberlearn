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
