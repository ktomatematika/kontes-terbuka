/* exported fill_contest_text */
function fill_contest_text() {
	var current = new Date();

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

			subtitle = 'Batas pengumpulan: ' + current_end_time.format_indo();
			time_remaining = '(' + current.indo_go_to(current_end_time) + ')';
		} else if (current_contest.data('result-released')) {
			$('.row > section').removeClass('col-sm-8');

			if (current < current_feedback_time) {
				subtitle = 'Hasil kontes sudah keluar! Jangan lupa, Anda ' +
					'bisa memberikan feedback ke kami paling lambat ' +
					current_feedback_time.format_indo() + '!';
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

$(document).ready(function() {
	$('#close-nag').click(function() {
		$('#nag-fade').fadeOut();
		$.post($(this).data('href'));
	});
});
