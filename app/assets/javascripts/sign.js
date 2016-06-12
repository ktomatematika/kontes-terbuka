var forgot = false;

$(document).ready(function() {

	// Use the hash to determine which form to show. Defaults to register.
	var hash = window.location.hash;
	if (hash === "#login") {
		$('#register').hide();
	} else if (hash === "#register") {
		$('#login').hide();
	} else {
		$('#login').hide();
	}

	// Show help text when input is selected
	$("#register .pre-help, #login .pre-help").addClass('hidden');
	$('#register input, #login input').focus(function() {
		if (!$(this).parent().hasClass('has-error')) {
			$(this).nextAll(".pre-help").removeClass('hidden');
		}
	});
	$('#register input, #login input').focusout(function() {
		$(this).nextAll(".pre-help").addClass('hidden');
	});

	// Fade in/out on switching forms.
	$('.move-form').click(function(e) {
		var right = $(this).attr("href");
		if (right === "#login") {
			restore_login();
			$('#register').fadeOut();
			$('#login').fadeIn();
		} else if (right === "#register") {
			$('#login').fadeOut();
			$('#register').fadeIn();
		}
		e.preventDefault();
	});

	// Forgot password
	var password_div = $('#login-form #password').parent();
	var remember_checkbox = $('#remember-me');
	$('#forgot-link').click(function() {
		if (forgot) {
			restore_login();
		} else {
			password_div.remove();	
			remember_checkbox.remove();
			$('#forgot-link').text("Kembali");
			$('#login-form').prepend('<p id="forgot-help">Masukkan username ' +
					'atau email Anda. Kami akan mengirim Anda petunjuk ' +
					'mengreset password.</p>');
			$('#login-form input[type=submit]').prop("value", "Kirim");
			forgot = true;
		}
	});

	function restore_login() {
		$('#login-form #username').parent().after(password_div);
		$('#login-form .left-footer').prepend(remember_checkbox);
		$('#forgot-link').text("Lupa password Anda?");
		$('#login-form #forgot-help').remove();
		$('#login-form input[type=submit]').prop("value", "Masuk");
		forgot = false;
	}

	// Adds peek functionality of password inputs
	var peek_buttons = $('.form-control-feedback.glyphicon-eye-open');	
	peek_buttons.mousedown(function(e) {
		$(e.target).parent().children('input').prop('type', 'input');
	});

	peek_buttons.mouseup(function(e) {
		$(e.target).parent().children('input').prop('type', 'password');
	});

	peek_buttons.mouseleave(function(e) {
		$(e.target).parent().children('input').prop('type', 'password');
	});
});
