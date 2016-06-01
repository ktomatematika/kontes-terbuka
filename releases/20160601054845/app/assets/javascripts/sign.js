var forgot = false;

$(document).ready(function() {

	// Which form to show?
	var hash = window.location.hash;
	if (hash === "#login") {
		$('#register').hide();
	} else if (hash === "#register") {
		$('#login').hide();
	} else {
		$('#login').hide();
	}

	// Synergize with bootstrap by adding certain bootstrap classes.
	$.validator.setDefaults({
		errorElement: "span",
		errorClass: "help-block",
		highlight: function(element, errorClass, validClass) {
			$(element).closest('.form-group').addClass('has-error');
			$(element).closest('.form-group').removeClass('has-success');
			if ($(element).prop('type') !== 'password') {
				$(element).nextAll('.glyphicon').removeClass('glyphicon-ok');
				$(element).nextAll('.glyphicon').addClass('glyphicon-remove');
			}
		},
		unhighlight: function(element, errorClass, validClass) {
			$(element).closest('.form-group').addClass('has-success');
			$(element).closest('.form-group').removeClass('has-error');
			if ($(element).prop('type') !== 'password') {
				$(element).nextAll('.glyphicon').removeClass('glyphicon-remove');
				$(element).nextAll('.glyphicon').addClass('glyphicon-ok');
			}
		},
		errorPlacement: function(error, element) {
			if (element.parent('.input-group').length) {
				error.insertAfter(element.parent());
			} else {
				if (element.prop('type') === 'checkbox') {
					error.insertAfter(element.next());
				} else {
					error.insertAfter(element);
				}
			}
		}
	});

	$.validator.addMethod('alphanum', function(value, elem, params) {
		return this.optional(elem) || /^[a-zA-Z0-9]+$/.test(value);
	});

	$("#register-form").validate({
		rules: {
			"user[username]": {
				required: true,
				minlength: 6,
				maxlength: 20,
				alphanum: true,
			},
			"user[email]": {
				required: true,
				email: true,
			},
			"user[password]": {
				required: true,
				minlength: 6,
			},
			"user[password_confirmation]": {
				required: true,
				minlength: 6,
				equalTo: "#user_password",
			},
			"user[fullname]": {
				required: true,
			},
			"user[province]": {
				min: 1,
			},
			"user[status]": {
				min: 1,
			},
			"user[school]": {
				required: true,
			},
			"confirm": {
				required: true,
			},
		},
		messages: {
			"user[username]": {
				required: "Tolong masukkan username.",
				minlength: "Username Anda harus minimal 6 karakter.",
				maxlength: "Username Anda tidak boleh lebih dari 20 karakter.",
				alphanum: "Anda hanya bisa menggunakan huruf dan angka saja."
			},
			"user[email]": {
				required: "Tolong masukkan email.",
				email: "Tolong masukan email yang valid."
			},
			"user[password]": {
				required: "Tolong masukkan password.",
				minlength: "Password Anda harus minimal 6 karakter."
			},
			"user[password_confirmation]": {
				required: "Tolong masukkan ulang password.",
				minlength: "Password Anda harus minimal 6 karakter.",
				equalTo: "Password Anda tidak sama dengan password sebelumnya."
			},
			"user[fullname]": {
				required: "Tolong masukkan nama lengkap Anda.",
			},
			"user[province]": {
				min: "Tolong masukkan provinsi Anda."
			},
			"user[status]": {
				min: "Tolong masukkan status Anda."
			},
			"user[school]": {
				required: "Tolong masukkan nama sekolah/institusi Anda." 
			},
			"confirm": {
				required: "Anda harus menyetujui syarat dan ketentuan " +
					"website ini."
			}
		}
	})

	$("#login-form").validate({
		rules: {
			"session[username]": {
				required: true,
			},
			"session[password]": {
				required: true,
				minlength: 6
			}
		},
		messages: {
			"session[username]": {
				required: "Tolong masukkan username/email Anda."
			},
			"session[password]": {
				required: "Tolong masukkan password.",
				minlength: "Password Anda harus minimal 6 karakter."
			}
		}
	});

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

	// jQuery fade in/out
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

	// Peek functionality of password boxes
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
