$(document).on('turbolinks:load', function() {
	function add_search() {
		var search_val = $('#users-search > input').val();
		var search = '';
		if (search_val !== '') {
			search = '?search=' + search_val;
		}
		document.location.href = window.location.pathname + search;
	}

	$('#users-search > .glyphicon').click(function() {
		add_search();
	});
	$('#users-search > #search').keyup(function(e) {
		if (e.keyCode === 13) {
			add_search();
		}
	});
});
