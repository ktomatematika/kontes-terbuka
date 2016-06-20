$(document).ready(function () {
// Synergize with bootstrap by adding certain bootstrap classes to tags.
	$.validator.setDefaults({
		errorElement: 'span',
		errorClass: 'help-block',
		highlight(element) {
			$(element).closest('.form-group').addClass('has-error');
			$(element).closest('.form-group').removeClass('has-success');
			if ($(element).prop('type') !== 'password') {
				$(element).nextAll('.glyphicon')
					.removeClass('glyphicon-ok')
					.addClass('glyphicon-remove')
					.empty();
			}
		},
		unhighlight(element) {
			$(element).closest('.form-group').addClass('has-success');
			$(element).closest('.form-group').removeClass('has-error');
			if ($(element).prop('type') !== 'password') {
				$(element).nextAll('.glyphicon')
					.addClass('glyphicon-ok')
					.removeClass('glyphicon-remove')
					.empty();
			}
		},
		errorPlacement(error, element) {
			if (element.parent('.input-group').length) {
				error.insertAfter(element.parent());
			} else {
				error.insertAfter(element);
			}
		},
	});

	// Adds a method to check whether a field is alphanumeric.
	$.validator.addMethod('alphanum', function (value, elem) {
		return this.optional(elem) || /^[a-zA-Z0-9]+$/.test(value);
	});

	$('#register-form').validate({
		// We don't register key up here; there will be a keyup listener
		// where it will call a throttled version of validation. Basically
		// it will only validate after 1000 ms of keyups, as to not send
		// too much AJAX requests.
		onkeyup: false,
		rules: {
			'user[username]': {
				required: true,
				minlength: 6,
				maxlength: 20,
				alphanum: true,
				// Sends post data to /check/. This is routed to
				// users#check_unique in the controller. This will return
				// JSON 'true' when username/email has not been taken and
				// JSON 'false' otherwise.
				remote: {
					url: '/check/',
					type: 'post',
					data: {
						username() {
							return $('#user_username').val();
						},
					},
				},
			},
			'user[email]': {
				required: true,
				email: true,
				// Same as above; sends post data.
				remote: {
					url: '/check/',
					type: 'post',
					data: {
						email() {
							return $('#user_email').val();
						},
					},
				},
			},
			'user[password]': {
				required: true,
				minlength: 6,
			},
			'user[password_confirmation]': {
				required: true,
				minlength: 6,
				equalTo: '#user_password',
			},
			'user[fullname]': {
				required: true,
			},
			'user[province_id]': {
				required: true,
			},
			'user[status_id]': {
				required: true,
			},
			'user[school]': {
				required: true,
			},
			'user[terms_of_service]': {
				required: true,
			},
		},
		messages: {
			'user[username]': {
				required: 'Tolong masukkan username.',
				minlength: 'Username Anda harus minimal 6 karakter.',
				maxlength: 'Username Anda tidak boleh lebih dari 20 karakter.',
				alphanum: 'Anda hanya bisa menggunakan huruf dan angka saja.',
				remote: 'Username tersebut sudah terpakai.',
			},
			'user[email]': {
				required: 'Tolong masukkan email.',
				email: 'Tolong masukan email yang valid.',
				remote: 'Username dengan email tersebut sudah ada.',
			},
			'user[password]': {
				required: 'Tolong masukkan password.',
				minlength: 'Password Anda harus minimal 6 karakter.',
			},
			'user[password_confirmation]': {
				required: 'Tolong masukkan ulang password.',
				minlength: 'Password Anda harus minimal 6 karakter.',
				equalTo: 'Password Anda tidak sama dengan password sebelumnya.',
			},
			'user[fullname]': {
				required: 'Tolong masukkan nama lengkap Anda.',
			},
			'user[province_id]': {
				required: 'Tolong masukkan provinsi Anda.',
			},
			'user[status_id]': {
				required: 'Tolong masukkan status Anda.',
			},
			'user[school]': {
				required: 'Tolong masukkan nama sekolah/institusi Anda.',
			},
			'user[terms_of_service]': {
				required: 'Anda harus menyetujui syarat dan ketentuan ' +
					'website ini.',
			},
		},
	});

	$('#login-form').validate({
		rules: {
			'session[username]': {
				required: true,
			},
			'session[password]': {
				required: true,
				minlength: 6,
			},
		},
		messages: {
			'session[username]': {
				required: 'Tolong masukkan username/email Anda.',
			},
			'session[password]': {
				required: 'Tolong masukkan password.',
				minlength: 'Password Anda harus minimal 6 karakter.',
			},
		},
	});

	var last = new Date();
	$('input').keyup(function (e) {
		var input = e.keyCode;

		// This checks if the key entered is backspace, characters, or delete.
		if (input === 8 || (input >= 32 && input <= 127)) {
			var t = e.target;

			// Remove bootstrap classes to show that we are performing
			// validation. In fact though we are just waiting for user input
			// to finish
			$(t).parent().removeClass('has-success').removeClass('has-error');

			var g = $(t).nextAll('.glyphicon');
			g.removeClass('glyphicon-ok').removeClass('glyphicon-remove');
			if (g.is(':empty') && $(t).prop('type') !== 'password') {
				g.append('<div class="loading"></div>');
			}

			$(t).nextAll('.help-block').hide();

			// Validate after 1000 milisecond.
			var validate_time = 1000;
			last = new Date();
			window.setTimeout(function () {
				if (new Date() - last >= validate_time) {
					$(t).valid();
				}
			}, validate_time);
		}
	});
});
