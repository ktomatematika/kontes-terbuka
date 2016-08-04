$(document).ready(function() {
	$('#users-search > .glyphicon').click(function() {
		var search_val = $('#users-search > input').val();
		var search = '';
		if (search_val !== '') {
			search = '?search=' + search_val
		}
		document.location.href = window.location.pathname + search;
	});
});
