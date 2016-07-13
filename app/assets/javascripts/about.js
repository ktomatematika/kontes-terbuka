$(document).ready(function() {
	var len_round_mult_3 = 3 * Math.ceil(about_us_data.length / 3)
	for (var i = 0; i < len_round_mult_3; i++) {
		var about_us_obj = about_us_data[i];

		// Add about us objects if not undefined
		if (typeof about_us_obj !== 'undefined') {
			$('#daftar-panitia').append(
					'<div class="col-md-4 col-sm-6 about-us-person "' +
					'data-name="' + about_us_obj.name + '" ' +
					'data-description="' + about_us_obj.description + '">' +
					'<h3>' + about_us_obj.name + '</h3>' +
					$('#about-us-pics').data(about_us_obj.image) +
					'</div>');
		}

		// Clearfix + add placeholders for about us description
		var clearfix_classes = 'clearfix visible-xs';
		if (i % 2 === 1) {
			clearfix_classes += ' visible-sm';
		}
		if (i % 3 === 2) {
			clearfix_classes += ' visible-md visible-lg';
		}
		$('#daftar-panitia').append(
				'<div class="' + clearfix_classes + '"></div>' +
				'<div class="about-us-description"></div>');
	}

	function reset_descriptions() {
		$('.about-us-description').slideUp('fast');
		$('.active-about-us').removeClass('active-about-us');
	}
	$('.about-us-description').hide();

	$('.about-us-person').click(function() {
		var me = $(this);
		var deactivate = me.hasClass('active-about-us');
		reset_descriptions();
		if (!deactivate) {
			me.addClass('active-about-us');
			me.nextAll('.visible-' + window_type() + ':first')
			  .nextAll('.about-us-description:first')
			  .text(me.data('description')).slideDown('fast');
			ga('send', 'event', 'about-us', 'view', $(this).data('name'));
		}
	});
});
