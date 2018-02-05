// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require vendors
//= require ./date_methods.js
//= require_tree .
//= require bootstrap-sprockets
//= require turbolinks
//= require jquery_nested_form
//= require browser_details

$(document).ready(function() {
	$('body').flowtype({
		minFont: 14,
		maxFont: 20,
	});

	$('#flash').hide().fadeIn('fast');
	$('#close-flash').click(function() {
		$('#flash').fadeOut('fast');
	});
});
