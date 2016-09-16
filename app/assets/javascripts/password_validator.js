$(document).ready(function() {
	$('#reset-password').validate({
		rules: {
			'[new_password]': {
				required: true,
				minlength: 6,
			},
			'[confirm_new_password]': {
				required: true,
				minlength: 6,
				equalTo: '#_new_password',
			},
		},
		messages: {
			'[new_password]': {
				required: 'Tolong masukkan password.',
				minlength: 'Password Anda harus minimal 6 karakter.',
			},
			'[confirm_new_password]': {
				required: 'Tolong masukkan ulang password.',
				minlength: 'Password Anda harus minimal 6 karakter.',
				equalTo: 'Password Anda tidak sama dengan password sebelumnya.',
			},
		},
		errorPlacement: function(error, element) {
			$('#reset-password-errors').empty().append(error);
		},
		unhighlight: function(element) {
			$('#reset-password-errors').empty();
		},
	});

	$('#change-password').validate({
		rules: {
			'[old_password]': {
				required: true,
				minlength: 6,
			},
			'[new_password]': {
				required: true,
				minlength: 6,
			},
			'[confirm_new_password]': {
				required: true,
				minlength: 6,
				equalTo: '#_new_password',
			},
		},
		messages: {
			'[old_password]': {
				required: 'Tolong masukkan password lama Anda.',
				minlength: 'Password Anda harus minimal 6 karakter.',
			},
			'[new_password]': {
				required: 'Tolong masukkan password baru Anda.',
				minlength: 'Password Anda harus minimal 6 karakter.',
			},
			'[confirm_new_password]': {
				required: 'Tolong masukkan ulang password baru Anda.',
				minlength: 'Password Anda harus minimal 6 karakter.',
				equalTo: 'Password Anda tidak sama dengan password sebelumnya.',
			},
		},
		errorPlacement: function(error, element) {
			$('#change-password-errors').empty().append(error);
		},
		unhighlight: function(element) {
			$('#change-password-errors').empty();
		},
	});
});
