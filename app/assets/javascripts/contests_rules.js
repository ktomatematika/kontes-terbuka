$(document).ready(function() {
	var current_contest = $('#rules-contest-data');
	if (current_contest.length !== 0) {
		var name = current_contest.data('name');
		var start_time = erb_to_date(current_contest.data('start-time'))
			.format_indo();
		var end_time = erb_to_date(current_contest.data('end-time'))
			.format_indo();
		var result_time = erb_to_date(current_contest.data('result-time'))
			.format_indo();
		var feedback_time = erb_to_date(current_contest.data('feedback-time'))
			.format_indo();

		$('#rules-text').html($('#rules-text').html()
				.replace(/\$name/g, name)
				.replace(/\$start_time/g, start_time)
				.replace(/\$end_time/g, end_time)
				.replace(/\$result_time/g, result_time)
				.replace(/\$feedback_time/g, feedback_time)
				.replace(/\$1hal1soal/g,
					$('#rules-contest-data').data('halsoal'))
				);
	}
});
