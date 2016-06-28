$(document).ready(function() {
	$('.about-us-person').click(function() {
		var container = $(this).parent();

		if (container.hasClass('active-about-us')) {
			container.removeClass('active-about-us');
		} else {
			console.log($('.active-about-us'));
			$('.active-about-us').removeClass('active-about-us');
			container.addClass('active-about-us');
		}
	});
});
