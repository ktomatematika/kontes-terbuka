// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
	'Agustus', 'September', 'Oktober', 'November', 'Desember'];
var days = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

$(document).ready(function() {
	var now = new Date();
	var current_year = now.getFullYear();
	var current_month = now.getMonth();
	var current_date = now.getDate();
	var displayed_year = current_year;
	var displayed_month = current_month;

	// Indexed by zero!
	function create_month_calendar(year, month) {
		function cell(text) {
			if (year === current_year && month === current_month &&
					text === current_date) {
				return ('<td class="today">' + text + '</td>');
			} else {
				return ('<td>' + text + '</td>');
			}
		}

		var first_day = new Date(year, month, 1).getDay();
		var last_date = new Date(year, month + 1, 0).getDate();
		var date = 1;
		var text = '<table class="table table-bordered ' +
			'table-condensed month-calendar">\n';

		text += '<thead>\n<tr>\n';
		for (var i = 0; i < days.length; i++) {
			text += ('<th>' + days[i] + '</th>\n');
		}
		text += '</tr>\n</thead>\n<tbody>\n<tr>\n';

		for (var i = 0; i < first_day; i++) {
			text += cell('');
		}
		for (var i = first_day; i < 7; i++) {
			text += cell(date);
			date++;
		}
		text += '</tr>\n';

		while (date <= last_date) {
			text += '<tr>\n';
			for (var i = 0; i < 7; i++) {
				if (date > last_date) {
					text += cell('');
				} else {
					text += cell(date);
					date++;
				}
			}
			text += '</tr>\n';
		}
		text += '</tbody>\n</table>';
		return text;
	}

	function update_year_calendar(year) {

		$('#calendar').empty();
		$('#this-time').text(year);
		$('#prev-time').text('Tahun Sebelumnya');
		$('#next-time').text('Tahun Selanjutnya');

		for (var month = 0; month < months.length; month++) {
			if (month % 3 == 0) {
				$('#calendar').append('<div class="row"></div>');
			}

			var append_text = '<div class="col-md-4">\n';
			append_text += create_month_calendar(year, month);
			append_text += '</div>';
			$('#calendar .row:last-child').append(append_text);
			$("#calendar table.month-calendar").last().prepend('<caption>' +
					months[month] + '</caption>');
		}
	}

	function update_month_calendar(year, month) {
		$('#calendar').empty();
		$('#this-time').text(months[month] + ' ' + year);
		if (window_type() === "xs") {
			$('#prev-time').text('<<');
			$('#next-time').text('>>');
		} else {
			$('#prev-time').text('Bulan Sebelumnya');
			$('#next-time').text('Bulan Selanjutnya');
		}

		$('#calendar').append(create_month_calendar(year, month));
	}

	function window_type() {
		var width = $(window).width();
		return (width >= 992) ? "md" : (width >= 768) ? "sm" : "xs";
	}

	function update_calendar() {
		if (window_type() === "md") {
			update_year_calendar(displayed_year);
		} else {
			update_month_calendar(displayed_year, displayed_month);
		}
	}

	update_calendar();
	$(window).resize(update_calendar);

	$('#prev-time').click(function(e) {
		if (window_type() === "md") {
			displayed_year--;
		} else if (displayed_month === 0) {
			displayed_month += 11;
			displayed_year--;
		} else {
			displayed_month--;
		}
		update_calendar();
		e.preventDefault();
	});

	$('#next-time').click(function(e) {
		if (window_type() === "md") {
			displayed_year++;
		} else if (displayed_month === 11) {
			displayed_month -= 11;
			displayed_year++;
		} else {
			displayed_month++;
		}
		update_calendar();
		e.preventDefault();
	});
});
