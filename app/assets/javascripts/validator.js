// Synergize with bootstrap by adding certain bootstrap classes to tags.
$.validator.setDefaults({
	errorElement: 'span',
	errorClass: 'help-block',
	highlight: function(element) {
		var elem = $(element);
		elem.closest('.form-group').addClass('has-error');
		elem.closest('.form-group').removeClass('has-success');
		if (elem.prop('type') !== 'password') {
			elem.nextAll('.glyphicon')
				.removeClass('glyphicon-ok')
				.addClass('glyphicon-remove')
				.empty();
		}
		if (elem.attr('name') === 'recaptcha') {
			$('.g-recaptcha').addClass('show-recaptcha-error');
		}
	},
	unhighlight: function(element) {
		var elem = $(element);
		elem.closest('.form-group').addClass('has-success');
		elem.closest('.form-group').removeClass('has-error');
		if (elem.prop('type') !== 'password') {
			elem.nextAll('.glyphicon')
				.addClass('glyphicon-ok')
				.removeClass('glyphicon-remove')
				.empty();
		}
		elem.removeClass('show-recaptcha-error');
	},
	errorPlacement: function(error, element) {
		if (element.attr('type') === 'checkbox') {
			error.insertAfter(element.parent());
		} else if (element.attr('name') === 'recaptcha') {
			error.insertAfter(element.next());
		} else {
			error.insertAfter(element);
		}
	},
});

// Adds a method to check whether a field is alphanumeric.
$.validator.addMethod('alphanum', function(value, elem, params) {
	return this.optional(elem) || /^[a-zA-Z0-9]+$/.test(value);
});

// Adds a method to check recaptcha.
$.validator.addMethod('recaptcha', function(value, elem, params) {
	return grecaptcha.getResponse().length !== 0;
});

// Adds a method to check for integers.
$.validator.addMethod('integer', function(value, elem, params) {
	return this.optional(elem) || /^-?\d+$/.test(value);
});

// Adds a method to check for positive integers.
$.validator.addMethod('positiveint', function(value, elem, params) {
	return this.optional(elem) || (value !== '0' && /^\d+$/.test(value));
});

// Adds a method to check that some files have been inputted.
$.validator.addMethod('has_data', function(value, elem, params) {
	return $(elem).prevAll('.fields:visible').length !== 0;
});
