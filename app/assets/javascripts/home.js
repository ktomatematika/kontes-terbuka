/* exported fill_home_text */
function fill_home_text() {
	var current = new Date();

	var next_important_contest = $('#home-contest-data');
	if (next_important_contest.length !== 0) {
		var end = erb_to_date(next_important_contest.data('end-time'));
		var results = erb_to_date(next_important_contest.data('result-time'));
		var results_released = next_important_contest.data('results-released');
		$('#next-contest-name').text(next_important_contest.data('name'));
		var subtitle_text, button_text;

		if (results_released) {
			button_text = 'Hasil sudah diumumkan!';
		} else if (current > results) {
			subtitle_text = ' Dikarenakan berbagai halangan, hasil kontes' +
				' belum keluar. Mohon maaf atas ketidaknyamannya dan' +
				' mohon bersabar :(';
			$('#home-btn-daftar').hide();
		} else if (current > end) {
			// Show time to results
			subtitle_text = 'Hasil diumumkan paling telat ' +
					results.format_indo();
			button_text = current.indo_go_to(results);
		} else {
			// Show time to next contest start
			var start = erb_to_date(next_important_contest.data('start-time'));
			subtitle_text = start.format_indo();
			subtitle_text += ' \u2013 ';
			subtitle_text += end.format_indo();

			if (start > current) {
				button_text = current.indo_go_to(start);
			} else {
				button_text = 'Kontes sudah dimulai!';
			}
		}

		$('#next-contest-time').text(subtitle_text);
		$('#home-btn-daftar').text(button_text);
	}
}
