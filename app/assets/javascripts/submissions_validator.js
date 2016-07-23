$(document).ready(function() {
	$('#bagian-a form').validate();
	$('#bagian-b form').validate({
		submitHandler: function(form) {
			if ($(form).find('.fields:visible').length !== 0) {
				form.submit();
			} else {
				alert('Anda tidak mengupload apa-apa!');
			}
		},
	});
	$.each($('#bagian-a form input[type=text]'), function(idx, elem) {
		$(elem).rules('add', {
			integer: true,
			messages: {
				integer: 'Jawaban Anda harus berupa bilangan bulat.',
			},
		});
	});
});

function validate_long_submissions() {
	$.each($('#bagian-b form input[type=text]'), function(idx, elem) {
		if ($.isEmptyObject($(elem).rules())) {
			$(elem).rules('add', {
				required: true,
				positiveint: true,
				messages: {
					required: 'Masukan nomor halaman Anda.',
					positiveint: 'Nomor halaman harus berupa bilangan bulat ' +
						'positif.',
				},
			});
		}
	});
	$.each($('#bagian-b form input[type=file]'), function(idx, elem) {
		if ($.isEmptyObject($(elem).rules())) {
			$(elem).rules('add', {
				required: true,
				extension: 'docx|doc|pdf|zip|jpg|jpeg|png',
				messages: {
					required: 'Masukan file Anda.',
					extension: 'File yang Anda upload tidak diterima. ' +
						'Pastikan filenya memiliki extension ' +
						'docx/doc/pdf/zip/jpg/jpeg/png.'
				},
			});
		}
	});
}
