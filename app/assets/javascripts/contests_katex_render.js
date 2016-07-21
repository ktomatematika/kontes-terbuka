$(document).ready(function() {
	var problems = $('.latex');

	$.each($('.math.inline'), function(idx, prob) {
		katex.render(prob.innerText, prob)
	});
	$.each($('.math.display'), function(idx, prob) {
		katex.render(prob.innerText, prob, { displayMode: true })
	});
});
