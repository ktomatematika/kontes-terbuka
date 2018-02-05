$(document).on('turbolinks:load', function() {
	var problems = $('.latex');

	$.each(problems, function(j, label) {
		renderMathInElement(label, {
			delimiters: [
				{ left: '$', right: '$', display: false },
				{ left: '\\[', right: '\\]', display: true },
			],
		});
	});
});
