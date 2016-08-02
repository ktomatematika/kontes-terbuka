$(document).ready(function() {
	$('#users-search > .glyphicon').click(function() {
		window.location.redirect(window.location.host + window.location.pathname + '?search=' + $("#users-search > input").val());
	});
});
