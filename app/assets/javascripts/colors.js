function load_colors() {
  var shade = $('#essential-data').data('color');
  $('.btn, .point-image, .has-shade').attr('data-shade', shade);
}

$(document).on('turbolinks:load', load_colors);
