function load_colors() {
	var shade = $('#essential-data').data('color');
	$('.btn, .has-shade').attr('data-shade', shade);
}

$(document).ready(load_colors);
