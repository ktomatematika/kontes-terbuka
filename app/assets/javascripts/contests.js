// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
	'Agustus', 'September', 'Oktober', 'November', 'Desember'];
var days = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

function cell(text) {
	return ('<td>' + text + '</td>');
}

$(document).ready(function() {
	var now = new Date();
	var current_year = now.getFullYear();
	var displayed_year = current_year;

	function update_calendar(year) {
		$('#calendar').empty();
		$('#this-year').empty();
		$('#this-year').append(year);

		for (var month = 0; month < months.length; month++) {
			var first_day = new Date(year, month, 1).getDay();
			var last_date = new Date(year, month + 1, 0).getDate();
			var date = 1;

			if (month % 3 == 0) {
				$('#calendar').append('<div class="row"></div>');
			}

			var append_text = '<div class="col-md-4">\n';
			append_text += '<table class="table table-bordered ' +
				'table-condensed month-calendar">\n';
			append_text += '<caption>' + months[month] + '</caption>\n';
			append_text += '<thead>\n<tr>\n';
			for (var i = 0; i < days.length; i++) {
				append_text += ('<th>' + days[i] + '</th>\n');
			}
			append_text += '</thead>\n<tbody>\n<tr>\n';

			for (var i = 0; i < first_day; i++) {
				append_text += cell('');
			}
			for (var i = first_day; i < 7; i++) {
				append_text += cell(date);
				date++;
			}
			append_text += '</tr>\n';

			while (date <= last_date) {
				append_text += '<tr>\n';
				for (var i = 0; i < 7; i++) {
					if (date > last_date) {
						append_text += cell('');
					} else {
						append_text += cell(date);
						date++;
					}
				}
				append_text += '</tr>\n';
			}
			append_text += '</tbody>\n</table>\n</div>\n';

			$('#calendar .row:last-child').append(append_text);
		}
	}

	update_calendar(current_year);

	$('#prev-year').click(function() {
		displayed_year--;
		update_calendar(displayed_year);
	});

	$('#next-year').click(function() {
		displayed_year++;
		update_calendar(displayed_year);
	});
});
