var REFRESH_TIME = 1000;

function update_regularly() {
	var current = new Date();

	// home#index contest details
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

	// contests#show time remaining, enable contest
	var current_contest = $('#contest-data');
	if ($('#contest-data').length !== 0) {
		$('#contest-name').text(current_contest.data('name'));

		var current_start_time = erb_to_date(
				current_contest.data('start-time'));
		var current_end_time = erb_to_date(
				current_contest.data('end-time'));
		var current_result_time = erb_to_date(
				current_contest.data('result-time'));
		var current_feedback_time = erb_to_date(
				current_contest.data('feedback-time'));

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
