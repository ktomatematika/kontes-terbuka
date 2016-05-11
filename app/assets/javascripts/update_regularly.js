function update_regularly() {
	var current = new Date();

	// home/index contest details
	var next_contest = $('#contest-data').data('next');
	if (next_contest !== null && next_contest !== undefined) {
		var start = new Date(next_contest.start_time);
		var end = new Date(next_contest.end_time);

		$('#next-contest-name').text(next_contest.name);
		var time = start.format_indo();
		time += ' \u2013 ';
		time += end.format_indo();
		$('#next-contest-time').text(time);

		if (start > current) {
			$('home-btn-daftar').prop('disabled', true);
			var text = current.indo_go_to(start);
		} else {
			$('#home-btn-daftar').prop('disabled', false);
			var text = "Kontes sudah dimulai!";
		}
		$('#home-btn-daftar').text(text);
	}

	// contests/id time remaining, enable contest
	var current_contest = $('#contest-data').data('current-contest');
	if (current_contest !== null && current_contest !== undefined) {
		var end_time = new Date(current_contest.end_time);
		var contest_time_remaining = "(" + current.indo_go_to(end_time) + ")";
		$('#contest-time-remaining').text(contest_time_remaining);
	}
}

setInterval(update_regularly, 1000);
