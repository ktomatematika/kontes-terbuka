$(document).ready(function() {
	$('.feedback-time').text((new Date($('.feedback-time').text())).format_indo());
});
