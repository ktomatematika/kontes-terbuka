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
});
