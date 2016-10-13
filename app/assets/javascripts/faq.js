$(document).ready(function() {
	for (var i = 0; i < faq_data.length; i++) {
		var data = faq_data[i];
		$('#faq-entries').append(
				'<div class="faq-container" data-category=' +
				data.category + '>' +
				'<div class="faq question">' + data.question + '</div>' +
				'<div class="faq answer">' + data.answer + '</div>' +
				'</div>');
	}

	for (var i = 0; i < categories.length; i++) {
		var data = categories[i];
		$('#categories').append('<div class="faq-category" data-category=' +
				i + '>' + data + '</div>');
	}
	$('.faq-category').css('width', 100 / categories.length + '%');

	$('.faq-container').hide();
	$('.faq-category[data-category="0"]').addClass('faq-category-active');
	$('.faq-container[data-category="0"]').show();

	$('.answer').hide();
	$('.question').click(function() {
		var answer = $(this).next();
		var deactivate = answer.css('display') !== 'none';
		$('.answer').slideUp('fast');
		$('.question-active').removeClass('question-active');
		if (!deactivate) {
			$(this).addClass('question-active');
			$(this).next().slideDown('fast');
		}
	});

	$('.faq-category').click(function() {
		if (!$(this).hasClass('faq-category-active')) {
			$('.faq-category-active').removeClass('faq-category-active');
			$(this).addClass('faq-category-active');

			var category = $(this).data('category');

			$('.faq-container').fadeOut('fast');
			setTimeout(function() {
				$('.faq-container[data-category="' + category + '"]')
					.fadeIn('fast');
			}, 200);
		}
	});
});
