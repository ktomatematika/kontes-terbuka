//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function choose_color() {
	var color = $('#warna').data('data');
	var possible = ["red", "green", "blue", "yellow"];

	// Default value
	if (color === "") { color = "Sistem"; }

	if (color === "Kosong") {
		return "";
	} else if (color === "Sistem") {
		return possible[now.getMonth() % 4];
	} else if (color === "Acak") {
		return possible[now % 4];
	} else if (color === "Merah") {
		return "red";
	} else if (color === "Hijau") {
		return "green";
	} else if (color === "Biru") {
		return "blue";
	} else if (color === "Kuning") {
		return "yellow";
	}
}

function load_colors() {
	var shade = choose_color();
	$('.has-shade').attr("data-shade", shade);
}

$(document).ready(load_colors);
