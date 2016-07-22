$(document).ready(function() {
	var next_contest = $('#welcome-contest-data');
	if (next_contest.length !== 0) {
		var start = erb_to_date(next_contest.data('start-time'));
		var end = erb_to_date(next_contest.data('end-time'));
		var name = next_contest.data('name');
		var contest_text;

		if (next_contest.data('currently-in-contest')) {
			contest_text = 'KONTES SUDAH DIMULAI!';	
		} else {
			contest_text = start.format_indo() + '\u2013' + end.format_indo();
		}
		$('#welcome-next-contest').text('Kontes berikutnya: '
			+ name + ' (' + contest_text + ')');
	}
});
