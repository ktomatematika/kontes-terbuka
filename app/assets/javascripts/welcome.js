$(document).ready(function () {
	var next_contest = $('#welcome-contest-data').data('next');
	if (typeof next_contest !== 'undefined') {
		var start = new Date(next_contest.start_time);
		var end = new Date(next_contest.end_time);

		$('#welcome-next-contest').text('Kontes berikutnya: '
				+ next_contest.name + ' (' + start.format_indo() +
					'\u2013' + end.format_indo() + ')');
	}
});
