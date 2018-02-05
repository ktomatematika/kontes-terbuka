$(document).on('turbolinks:load', function() {
	var current_contest = $('#rules-contest-data');
	if (current_contest.length !== 0) {
		var name = current_contest.data('name');
		var start_time = current_contest.data('start-time');
		var end_time = current_contest.data('end-time');
		var result_time = current_contest.data('result-time');
		var feedback_time = current_contest.data('feedback-time');

		$('#rules-text').html($('#rules-text').html()
				.replace(/%name/g, name)
				.replace(/%start_time/g, start_time)
				.replace(/%end_time/g, end_time)
				.replace(/%result_time/g, result_time)
				.replace(/%feedback_time/g, feedback_time)
				.replace(/%1hal1soal/g,
					$('#rules-contest-data').data('halsoal'))
				);
	}
});
