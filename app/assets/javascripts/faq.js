$(document).ready(function() {
	for (var i = 0; i < faq_data.length; i++) {
		var data = faq_data[i];
		$('#faq-entries').append(
				'<div class="faq question">' + data.question + '</div>' +
				'<div class="faq answer">' + data.answer + '</div>');
	}

	$('.answer').hide();
	$('.question').click(function() {
		var answer = $(this).next();
		var deactivate = answer.css('display') !== 'none';
		$('.answer').slideUp('fast');
		if (!deactivate) {
			$(this).next().slideDown('fast');
		}
	});
});
