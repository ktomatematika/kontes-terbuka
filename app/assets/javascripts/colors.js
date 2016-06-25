// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function choose_color() {
	var color = $('#essential-data').data('color').name;
	var possible = ['red-color', 'green-color', 'blue-color', 'yellow-color'];

	// Default value
	if (typeof color === 'undefined') { color = 'Sistem'; }

	if (color === 'Kosong') {
		return '';
	} else if (color === 'Sistem') {
		return possible[now.getMonth() % possible.length];
	} else if (color === 'Acak') {
		return possible[now % possible.length];
	} else if (color === 'Merah') {
		return 'red-color';
	} else if (color === 'Hijau') {
		return 'green-color';
	} else if (color === 'Biru') {
		return 'blue-color';
	} else if (color === 'Kuning') {
		return 'yellow-color';
	}
}

function load_colors() {
	var shade = choose_color();
	$('.has-shade').attr('data-shade', shade);
}

$(document).ready(load_colors);
