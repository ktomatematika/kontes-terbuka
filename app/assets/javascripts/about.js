$(document).ready(function() {
	$('.about-us-person').click(function() {
		if ($(this).hasClass('active-about-us')) {
			$(this).removeClass('active-about-us');
		} else {
			$('.active-about-us').removeClass('active-about-us');
			$(this).addClass('active-about-us');
		}
	});
});
