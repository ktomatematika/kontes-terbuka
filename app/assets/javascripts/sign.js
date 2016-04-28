//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

$().ready(function() {

	// Synergize with bootstrap by adding certain bootstrap classes.
	$.validator.setDefaults({
		errorElement: "span",
		errorClass: "help-block",
		highlight: function(element, errorClass, validClass) {
			$(element).closest('.form-group').addClass('has-error');
			$(element).closest('.form-group').removeClass('has-success');
			$(element).nextAll('.glyphicon').removeClass('glyphicon-ok');
			$(element).nextAll('.glyphicon').addClass('glyphicon-remove');
		},
		unhighlight: function(element, errorClass, validClass) {
			$(element).closest('.form-group').addClass('has-success');
			$(element).closest('.form-group').removeClass('has-error');
			$(element).nextAll('.glyphicon').removeClass('glyphicon-remove');
			$(element).nextAll('.glyphicon').addClass('glyphicon-ok');
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
				alphanum: true
			},
			"user[email]": {
				required: true,
				email: true
			},
			"user[password]": {
				required: true,
				minlength: 6
			},
			"user[password_confirmation]": {
				required: true,
				minlength: 6,
				equalTo: "#user_password" },
			"user[fullname]": {
				required: true,
			},
			"user[province]": {
				min: 1
			},
			"user[status]": {
				min: 1
			},
			"user[school]": {
				required: true,
			},
				"confirm": {
					required: true
				}
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

	// When a form fades out, disable its controls
	$('.wrong-form > a').click(function() {
		var hash = window.location.hash;

		if (hash === "#to-register") {
			$('#login-form').find('input').prop('disabled', false);
			$('#register-form').find('input').prop('disabled', true);
		} else if (hash === "#to-login") {
			$('#register-form').find('input').prop('disabled', false);
			$('#login-form').find('input').prop('disabled', true);
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
});
