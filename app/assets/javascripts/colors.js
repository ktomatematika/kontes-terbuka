//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function choose_color() {
	var num = now % 4;

	if (num === 0) {
		return "red";
	} else if (num === 1) {
		return "blue";
	} else if (num === 2) {
		return "green";
	} else if (num === 3) {
		return "yellow";
	}
}

function load_colors() {
	var shade = choose_color();
	$('.has-shade').attr("data-shade", shade);
}

$(document).ready(load_colors);
