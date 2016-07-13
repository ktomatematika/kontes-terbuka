/* eslint-disable no-inner-declarations, no-redeclare */
var MONTH_CALENDAR_IN_A_ROW = 3;
var MONTH_CALENDAR_SIZE = MONTHS_IN_A_YEAR / MONTH_CALENDAR_IN_A_ROW;

$(document).ready(function() {
	var contests = $('#contests-data').data();

	if (typeof contests !== 'undefined') {
		var current_year = now.getFullYear();
		var current_month = now.getMonth();
		var displayed_year = current_year;
		var displayed_month = current_month;

		// Convert start_time and end_time to Javascript Date objects
		$.each(contests, function(id, contest) {
			contest.start_time = new Date(contest.start_time);
			contest.end_time = new Date(contest.end_time);
		});

		// month is indexed from zero!
		function create_month_calendar(year, month) {
			function create_cell(date) {
				var cell_class = [];
				var txt = '<div';
				var class_text = '';
				var additions = '';
				var close_opening_tag = '>';
				var contents = date;
				var closing_tag = '</div>';

				cell_class.push('td');

				if (date !== '') {
					var date_obj = new Date(year, month, date);

					// Give the class 'contest-cell' to cells with contests and
					// give them popover info

					var cell_contest_id = 0;
					$.each(contests, function(id, contest) {
						if (cell_contest_id === 0 &&
								(date_obj.compare_day(contest.start_time) >= 0
								&& date_obj.compare_day(contest.end_time)
								<= 0)) {
							cell_class.push('contest-cell');
							cell_contest_id = id;

							additions += 'data-toggle="popover" ';
							additions += 'data-container="body" ';
							additions += 'data-trigger="hover" ';
							additions += 'data-placement="top" ';
							additions += 'data-html="true" ';
							additions += 'title="' + contest.name + '" ';

							var content = 'Dari ' +
								contest.start_time.format_indo() + ' sampai '
								+ contest.end_time.format_indo()
								+ '<br>Format: '
								+ contest.number_of_short_questions
								+ ' isian dan '
								+ contest.number_of_long_questions + ' uraian';
							additions += 'data-content="' + content + '"';
						}
					});

					if (now.compare_day(date_obj) === 0) {
						cell_class.push('today');
					}
				}

				// Should we add a tag? --> link to contest
				if (cell_class.indexOf('contest-cell') !== -1) {
					var link = contests[cell_contest_id].path;
					var today_pos = cell_class.indexOf('today');
					if (today_pos !== -1) {
						cell_class.splice(today_pos);
						txt = '<a href=' + link +
							' class="td today has-contest">' + txt;
					} else {
						txt = '<a href=' + link +
							' class="has-contest td">' + txt;
					}

					closing_tag += '</a>';
					cell_class.splice(cell_class.indexOf('td'), 1);
				}

				if (cell_class.length !== 0) {
					class_text += ' class="';
					for (var i = 0; i < cell_class.length; i++) {
						class_text += cell_class[i];
						if (i !== cell_class.length - 1) {
							class_text += ' ';
						}
					}
					class_text += '"';
				}
				return txt + class_text + additions + close_opening_tag +
						contents + closing_tag;
			}

			// Start building the calendar
			var first_day = new Date(year, month, 1).getDay();
			var last_date = new Date(year, month + 1, 0).getDate();
			var date = 1;
			var text = '<div class="table table-bordered ' +
				'table-condensed month-calendar has-shade">';

			text += '<div class="thead"><div class="tr">';
			for (var i = 0; i < short_days.length; i++) {
				text += '<div class="th">' + short_days[i] + '</div>';
			}
			text += '</div></div><div class="tbody"><div class="tr">';

			for (var i = 0; i < first_day; i++) {
				text += create_cell('');
			}
			for (var i = first_day; i < DAYS_IN_A_WEEK; i++) {
				text += create_cell(date);
				date++;
			}
			text += '</div>';

			while (date <= last_date) {
				text += '<div class="tr">';
				for (var i = 0; i < DAYS_IN_A_WEEK; i++) {
					if (date > last_date) {
						text += create_cell('');
					} else {
						text += create_cell(date);
						date++;
					}
				}
				text += '</div>';
			}
			text += '</div>';
			return text;
		}

		function update_year_calendar(year) {
			$('#calendar').empty();
			$('#this-time').text(year);
			$('#prev-time').text('Tahun Sebelumnya');
			$('#next-time').text('Tahun Selanjutnya');

			for (var month = 0; month < months.length; month++) {
				if (month % MONTH_CALENDAR_IN_A_ROW === 0) {
					$('#calendar').append('<div class="row"></div>');
				}

				var append_text = '<div class="col-md-' + MONTH_CALENDAR_SIZE +
					'">';
				append_text += create_month_calendar(year, month);
				append_text += '</div>';
				$('#calendar .row:last-child').append(append_text);
				$('#calendar .table.month-calendar').last().prepend(
						'<div class="caption">' + months[month] + '</div>');
			}
		}

		function update_month_calendar(year, month) {
			$('#calendar').empty();
			$('#this-time').text(months[month] + ' ' + year);
			if (window_type() === 'xs') {
				$('#prev-time').text('<<');
				$('#next-time').text('>>');
			} else {
				$('#prev-time').text('Bulan Sebelumnya');
				$('#next-time').text('Bulan Selanjutnya');
			}

			$('#calendar').append(create_month_calendar(year, month));
		}

		function update_calendar() {
			if (window_type() === 'md') {
				update_year_calendar(displayed_year);
			} else {
				update_month_calendar(displayed_year, displayed_month);
			}
			$('[data-toggle="popover"]').popover();
			load_colors();
		}

		update_calendar();
		$(window).resize(update_calendar);

		$('#prev-time').click(function(e) {
			if (window_type() === 'md') {
				displayed_year--;
			} else if (displayed_month === 0) {
				displayed_month += MONTHS_IN_A_YEAR - 1;
				displayed_year--;
			} else {
				displayed_month--;
			}
			update_calendar();
			e.preventDefault();
		});

		$('#next-time').click(function(e) {
			if (window_type() === 'md') {
				displayed_year++;
			} else if (displayed_month === MONTHS_IN_A_YEAR - 1) {
				displayed_month -= MONTHS_IN_A_YEAR - 1;
				displayed_year++;
			} else {
				displayed_month++;
			}
			update_calendar();
			e.preventDefault();
		});
	}
});
