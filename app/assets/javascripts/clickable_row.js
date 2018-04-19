$(document).on('turbolinks:load', function() {
  $('.clickable-row').click(function(e) {
    var link = $(e.currentTarget).data('link');
    if (typeof link !== 'undefined') {
      window.location.href = link;
    }
  });
});
