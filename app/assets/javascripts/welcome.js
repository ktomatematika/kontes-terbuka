$(document).ready(function() {
	var next_contest = $('#welcome-contest-data');
	if (next_contest.length !== 0) {
		var contest_text;

		if (next_contest.data('name') === null) {
			contest_text = '';
		} else {
			var start = erb_to_date(next_contest.data('start-time'));
			var end = erb_to_date(next_contest.data('end-time'));
			var name = next_contest.data('name');

			if (next_contest.data('currently-in-contest')) {
				contest_text = 'Kontes berikutnya: ' + name +
					'(KONTES SUDAH DIMULAI!)';
			} else {
				contest_text = 'Kontes berikutnya: ' + name + ' (' + start.format_indo() + '\u2013' + end.format_indo() + ')';
			}
		}
		$('#welcome-next-contest').text(contest_text);
	}
});
