function fill_home_text() {
	var current = new Date();

	var next_important_contest = $('#home-contest-data');
	if (next_important_contest.length !== 0) {
		var end = erb_to_date(next_important_contest.data('end-time'));
		$('#next-contest-name').text(next_important_contest.data('name'));
		var button_text;

		if (current > end) {
			// Show time to results
			var results =
				erb_to_date(next_important_contest.data('result_time'));
			$('#next-contest-time').text('Hasil diumumkan paling telat ' +
					results.format_indo());
			button_text = current.indo_go_to(results);
		} else {
			// Show time to next contest start
			var start = erb_to_date(next_important_contest.data('start-time'));
			var time = start.format_indo();
			time += ' \u2013 ';
			time += end.format_indo();
			$('#next-contest-time').text(time);

			if (start > current) {
				$('home-btn-daftar').attr('disabled', true);
				button_text = current.indo_go_to(start);
			} else {
				$('#home-btn-daftar').removeAttr('disabled', false);
				$('#home-btn-daftar').prop('href',
						$('#home-contest-data').data('url'));
				button_text = 'Kontes sudah dimulai!';
			}
		}

		$('#home-btn-daftar').text(button_text);
	}
}
