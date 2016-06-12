function update_regularly() {
	var current = new Date();

	// home/index contest details
	var next_important_contest = $('#home-contest-data').data('next');
	if (next_important_contest !== null &&
			next_important_contest !== undefined) {
		var end = new Date(next_important_contest.end_time);
		$('#next-contest-name').text(next_important_contest.name);

		if (current > end) {
			// Show time to results
			var results = new Date(next_important_contest.result_time);
			$('#next-contest-time').text('Hasil diumumkan paling telat ' +
					results.format_indo());
			var text = current.indo_go_to(results);
		} else {
			// Show time to next contest start
			var start = new Date(next_important_contest.start_time);
			var time = start.format_indo();
			time += ' \u2013 ';
			time += end.format_indo();
			$('#next-contest-time').text(time);

			if (start > current) {
				$('home-btn-daftar').attr('disabled', true);
				var text = current.indo_go_to(start);
			} else {
				$('#home-btn-daftar').removeAttr('disabled', false);
				$('#home-btn-daftar').prop('href',
						$('#home-contest-data').data('url'));
				var text = "Kontes sudah dimulai!";
			}
		}

		$('#home-btn-daftar').text(text);
	}

	// contests/id time remaining, enable contest
	var current_contest = $('#contest-data').data('current-contest');
	if (current_contest !== null && current_contest !== undefined) {
		$('#contest-name').text(current_contest.name);

		var start_time = new Date(current_contest.start_time);
		var end_time = new Date(current_contest.end_time);
		var results = new Date(current_contest.result_time);
		var feedback = new Date(current_contest.feedback_time);

		var subtitle;
		var time_remaining;

		if (current < start_time) {
			// Contest has not started
			subtitle = "Kontes dimulai " + start_time.format_indo() +
				". Mohon bersabar!";
			time_remaining = "(" + current.indo_go_to(start_time) + ")";

			// Has the state changed?
			if (position !== 0) {
				window.location.reload();
			}
		} else if (current <= end_time) {
			// Contest has not ended
			$(".row > section").addClass("col-sm-8");

			var isian = $('.isian > label');
			for (var i = 0; i < isian.length; i++) {
				var prob = isian.get(i);
				renderMathInElement(prob, {
					delimiters: [
					{ left: "$", right: "$", display: false },
					{ left: "$$", right: "$$", display: true },
					{ left: "\\[", right: "\\]", display: true },
					{ left: "\\(", right: "\\)", display: false }
					]
				});
			}

			subtitle = "Batas pengumpulan: " + end_time.format_indo();
			time_remaining = "(" + current.indo_go_to(end_time) + ")";

			// Has the state changed?
			if (position !== 1) {
				window.location.reload();
			}
		} else if (current < results) {
			// Results has not been released
			$('.row > section').removeClass('col-sm-8');

			subtitle = "Kontes sudah selesai. Hasil kontes akan keluar " +
				"paling lambat " + results.format_indo() + ". Mohon bersabar!";
			time_remaining = "(" + current.indo_go_to(results) + ")";

			// Has the state changed?
			if (position !== 2) {
				window.location.reload();
			}
		} else {
			// Results should be released manually.

			subtitle = "Dikarenakan berbagai halangan, hasil kontes belum " +
				"keluar. Mohon maaf atas ketidaknyamannya dan mohon " +
				"bersabar :(";
			time_remaining = "";
		}

		$('#subtitle').text(subtitle);
		$('#time-remaining').text(time_remaining);
	}
}

$(document).ready(update_regularly);
setInterval(update_regularly, 1000);
