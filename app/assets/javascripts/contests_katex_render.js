$(document).ready(function() {
	var problems = $('.problem-statement, .admin-statement-preview');

	$.each(problems, function(j, label) {
		renderMathInElement(label, {
			delimiters: [
				{ left: '$', right: '$', display: false },
				{ left: '$$', right: '$$', display: true },
				{ left: '\\[', right: '\\]', display: true },
				{ left: '\\(', right: '\\)', display: false },
			],
		});
	});
});
