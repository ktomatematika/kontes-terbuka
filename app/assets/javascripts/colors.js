//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function choose_color() {
	var num = Date.now() % 4;
	var color = "";

	if (num === 0) {
		color = "red";
	} else if (num === 1) {
		color = "blue";
	} else if (num === 2) {
		color = "green";
	} else if (num === 3) {
		color = "yellow";
	}

	color += "-color";
	return color;
}

$(document).ready(function() {
	var shade = choose_color();	
	$('.has-shade').addClass(shade);
});
