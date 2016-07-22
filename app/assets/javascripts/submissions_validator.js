$(document).ready(function() {
	$('#bagian-a form').validate();
	$('#bagian-b form').validate();
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
				digits: true,
				messages: {
					required: 'Masukan nomor halaman Anda.',
					digits: 'Nomor halaman harus berupa bilangan bulat.',
				},
			});
		}
	});
	$.each($('#bagian-b form input[type=file]'), function(idx, elem) {
		if ($.isEmptyObject($(elem).rules())) {
			$(elem).rules('add', {
				required: true,
				extension: 'docx',
				messages: {
					required: 'Masukan file Anda.',
					extension: 'File yang Anda upload tidak diterima.' +
						'Pastikan filenya memiliki extension ' +
						'docx/doc/pdf/zip/jpg/jpeg/png.'
				},
			});
		}
	});
}
