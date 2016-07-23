function distinct(arr) {
	for (var i = 0; i < arr.length; i++) {
		for (var j = 0; j < i; j++) {
			if (arr[i] === arr[j]) {
				return false;
			}
		}
	}
	return true;
}

$(document).ready(function() {
	$('#bagian-a form').validate();
	$('#bagian-b form').validate({
		submitHandler: function(form) {
			var inputs = $(form).find('.fields:visible input[type=text]');
			var page_numbers = $.map(inputs, function(elem) {
				return $(elem).val();
			});

			if (page_numbers.length === 0) {
				alert('Anda tidak mengupload apa-apa!');
			} else if (!distinct(page_numbers)) {
				alert('Nomor halaman Anda ada yang duplikat!');
			} else {
				form.submit();
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
