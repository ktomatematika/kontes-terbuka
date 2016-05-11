$(document).ready(function() {
	var current_contest = $('#contest-data').data('current-contest');

	if (current_contest !== undefined) {
		var end_time = new Date(current_contest.end_time);

		$('#contest-name').text(current_contest.name);
		var contest_time_text = "Batas pengumpulan: " +
			end_time.format_indo();
		$('#contest-time').text(contest_time_text);
	}
});
