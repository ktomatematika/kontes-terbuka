$(document).ready(function() {

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
		onfocusout: false, onkeyup: false, onclick: false,
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

	// Check if user exists or not as user enters username/email
	// in registration form
	var throttle = (function() {
		var last = new Date();
		return function(delay_ms, callback) {
			last = new Date();
			window.setTimeout(function() {
				if (new Date() - last >= delay_ms) {
					callback();
				}
			}, delay_ms);
		}
		return function(delay_ms, post_data, start, on_non_exists, on_exists) {
			last = new Date();
			window.setTimeout(function() {
				if (new Date() - last >= delay_ms) {
					$.post('/check', post_data, function(data) {
						if (data === "true") {
							on_non_exists();
						} else {
							on_exists();
						}
					});
				}
			}, delay_ms);

		};
	})();

	var validator = $('#register-form').validate();
	$('#user_username').keyup(function() {
		$('#user_username-error').hide();
		throttle(1000, function() {
			var input = $('#user_username');
			$.post('/check', {username: input.val()},  function(data) {
				$('#user-help').hide();	
				if (data === "true") {
					input.valid();
				} else {
					validator.showErrors({
						'user[username]': 'Username tersebut tidak tersedia.',
					});
				}
			});
		});
	});

	$('#user_email').keyup(function() {
		$('#user_email-error').hide();
		throttle(1000, function() {
			var input = $('#user_email');
			$.post('/check', {email: input.val()}, function(data) {
				if (data === "true") {
					input.valid();
				} else {
					validator.showErrors({
						'user[email]':
							'Akun dengan email tersebut sudah terpakai.'
					});
				}
			});
		});
	});

	$('input').keyup(function(e) {
		throttle(1000, function() {
			var t = e.target;
			if (t.id === 'user_password') {
				$('#pass-help').hide();
			}
			if (t.id !== 'user_username' && t.id !== 'user_email') {
				$(t).valid();
			}
		});
	});
});
