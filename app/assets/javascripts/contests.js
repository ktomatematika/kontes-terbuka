var position;

$(document).ready(function() {
	var current_contest = $('#contest-data').data('current-contest');
	if (current_contest !== null && current_contest !== undefined) {
		var start_time = new Date(current_contest.start_time);
		var end_time = new Date(current_contest.end_time);
		var results = new Date(current_contest.result_time);
		var feedback = new Date(current_contest.feedback_time);

		if (now < start_time) {
			position = 0;
		} else if (now <= end_time) {
			position = 1;
		} else if (now < results) {
			position = 2;
			$('#contest-info').append('<p>Sementara itu, Anda bisa berdiskusi di olimpiade.org</p>');
		} else if (now < feedback) {
			position = 3;
		} else {
			position = 4;
		}
	}

	current_contest = $('#rules-contest-data').data('contest');
	if (current_contest !== null && current_contest !== undefined) {
		var name = current_contest.name;	
		var start_time = new Date(current_contest.start_time).format_indo();
		var end_time = new Date(current_contest.end_time).format_indo();
		var result_time = new Date(current_contest.result_time).format_indo();
		var feedback_time = new Date(current_contest.feedback_time)
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
