$(document).ready(function () {
// Use the hash to determine which form to show. Defaults to register.
	var hash = window.location.hash;
	if (hash === '#login') {
		$('#register').hide();
		$('#forgot').hide();
	} else if (hash === '#register') {
		$('#login').hide();
		$('#forgot').hide();
	} else if (hash === '#forgot') {
		$('#register').hide();
		$('#login').hide();
	} else {
		$('#login').hide();
		$('#forgot').hide();
	}

	// Show help text when input is selected
	$('#register .pre-help, #login .pre-help').addClass('hidden');
	$('#register input, #login input').focus(function () {
		if (!$(this).parent().hasClass('has-error')) {
			$(this).nextAll('.pre-help').removeClass('hidden');
		}
	});
	$('#register input, #login input').focusout(function () {
		$(this).nextAll('.pre-help').addClass('hidden');
	});

	// Fade in/out on switching forms.
	$('.move-form').click(function (e) {
		var right = $(this).attr('href');
		if (right === '#login') {
			$('#register').fadeOut();
			$('#forgot').fadeOut();
			$('#login').fadeIn();
		} else if (right === '#register') {
			$('#login').fadeOut();
			$('#forgot').fadeOut();
			$('#register').fadeIn();
		} else if (right === '#forgot') {
			$('#register').fadeOut();
			$('#login').fadeOut();
			$('#forgot').fadeIn();
		}
		e.preventDefault();
	});

	// Adds peek functionality of password inputs
	var peek_buttons = $('.form-control-feedback.glyphicon-eye-open');
	peek_buttons.mousedown(function (e) {
		$(e.target).parent().children('input').prop('type', 'input');
	});

	peek_buttons.mouseup(function (e) {
		$(e.target).parent().children('input').prop('type', 'password');
	});

	peek_buttons.mouseleave(function (e) {
		$(e.target).parent().children('input').prop('type', 'password');
	});
});
