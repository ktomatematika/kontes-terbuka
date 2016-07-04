function choose_color() {
	var color = $('#essential-data').data('color').name;
	var possible = ['red', 'blue', 'green', 'yellow'];

	// Default value
	if (typeof color === 'undefined') { color = 'Sistem'; }

	if (color === 'Kosong') {
		return '';
	} else if (color === 'Sistem') {
		return possible[now.getMonth() % possible.length];
	} else if (color === 'Acak') {
		return possible[now % possible.length];
	} else if (color === 'Merah') {
		return 'red';
	} else if (color === 'Hijau') {
		return 'green';
	} else if (color === 'Biru') {
		return 'blue';
	} else if (color === 'Kuning') {
		return 'yellow';
	}
}

function load_colors() {
	var shade = choose_color();
	$('.has-shade').attr('data-shade', shade);
}

$(document).ready(load_colors);
