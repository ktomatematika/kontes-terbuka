var REFRESH_TIME = 1000;

function update_regularly() {
	var current = new Date();

	// home/index contest details
	var next_important_contest = $('#home-contest-data').data('next');
	if (typeof next_important_contest !== 'undefined') {
		var end = new Date(next_important_contest.end_time);
		$('#next-contest-name').text(next_important_contest.name);
		var button_text;

		if (current > end) {
			// Show time to results
			var results = new Date(next_important_contest.result_time);
			$('#next-contest-time').text('Hasil diumumkan paling telat ' +
					results.format_indo());
			button_text = current.indo_go_to(results);
		} else {
			// Show time to next contest start
			var start = new Date(next_important_contest.start_time);
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

	// contests/id time remaining, enable contest
	var current_contest = $('#contest-data').data('current-contest');
	if (typeof current_contest !== 'undefined') {
		$('#contest-name').text(current_contest.name);

		var current_start_time = new Date(current_contest.start_time);
		var current_end_time = new Date(current_contest.end_time);
		var current_result_time = new Date(current_contest.result_time);
		var current_feedback_time = new Date(current_contest.feedback_time);

		var subtitle = '';
		var time_remaining = '';

		if (current < current_start_time) {
			// Contest has not started
			subtitle = 'Kontes dimulai ' + current_start_time.format_indo() +
				'. Mohon bersabar!';
			time_remaining = '(' + current.indo_go_to(current_start_time) + ')';
		} else if (current < current_end_time) {
			// Contest has not ended
			$('.row > section').addClass('col-sm-8');

			var isian = $('.isian > label');
			for (var i = 0; i < isian.length; i++) {
				var prob = isian.get(i);
				renderMathInElement(prob, {
					delimiters: [
					{ left: '$', right: '$', display: false },
					{ left: '$$', right: '$$', display: true },
					{ left: '\\[', right: '\\]', display: true },
					{ left: '\\(', right: '\\)', display: false },
					],
				});
			}

			subtitle = 'Batas pengumpulan: ' + current_end_time.format_indo();
			time_remaining = '(' + current.indo_go_to(current_end_time) + ')';
		} else if (current_contest.result_released) {
			$('.row > section').removeClass('col-sm-8');

			if (current < current_feedback_time) {
				subtitle = 'Hasil kontes sudah keluar! Jangan lupa untuk ' +
					'memberikan feedback ke kami paling lambat ' +
					current_feedback_time.format_indo() + ', untuk mendapatkan' +
					' sertifikatnya!';
				time_remaining = '(' + current.indo_go_to(current_feedback_time)
					+ ')';
			}
		} else if (current < current_result_time) {
			// Results has not been released
			$('.row > section').removeClass('col-sm-8');

			subtitle = 'Kontes sudah selesai. Hasil kontes akan keluar ' +
				'paling lambat ' + current_result_time.format_indo() +
				'. Mohon bersabar!';
			time_remaining = '(' + current.indo_go_to(current_result_time) +
				')';
		} else {
			// Results should be released manually.
			subtitle = 'Dikarenakan berbagai halangan, hasil kontes belum ' +
				'keluar. Mohon maaf atas ketidaknyamannya dan mohon ' +
				'bersabar :(';
			time_remaining = '';
		}

		$('#subtitle').text(subtitle);
		$('#time-remaining').text(time_remaining);
	}
}

$(document).ready(update_regularly);
setInterval(update_regularly, REFRESH_TIME);
