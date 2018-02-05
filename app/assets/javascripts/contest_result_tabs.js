$(document).on('turbolinks:load', function() {
	$('.result-tables .contest-results').hide();
	$('.same-province').show();

	var links = $('.contest-result-tabs a');

	links.click(function(e) {
		e.preventDefault();
		links.parent().removeClass('active');
		$(this).parent().addClass('active');

		var tab = $(this).data('tab');
		if (tab === 'same_province') {
			$('.contest-results').hide();
			$('.same-province').show();
		} else if (tab === 'medallists') {
			$('.contest-results').hide();
			$('.medallists').show();
		}
	})
});
