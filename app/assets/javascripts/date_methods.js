/* exported now short_days MONTHS_IN_A_YEAR DAYS_IN_A_WEEK erb_to_date */

var now = new Date();
var months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
	'Agustus', 'September', 'Oktober', 'November', 'Desember'];
var short_days = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];
var long_days = ['Minggu', 'Senin', 'Selasa', 'Rabu',
	'Kamis', 'Jumat', 'Sabtu'];

var MONTHS_IN_A_YEAR = 12;
var DAYS_IN_A_WEEK = 7;

// erb_to_date: converts date given by IRB in content_tags to JS Date.
function erb_to_date(erb_string) {
	return new Date(erb_string.slice(1, -1));
}

/* compare_day: compares a day to another.
 * Returns positive if current date is after compared date,
 * negative if current date is before compared date,
 * zero if they are the same.
 * Example:
 * var a = new Date(2015, 3, 2);
 * var b = new Date(2015, 3, 3);
 * a.compare_day(b) returns an integer < 0.
 */

Date.prototype.compare_day = function(other) {
	var year_diff = this.getFullYear() - other.getFullYear();
	var month_diff = this.getMonth() - other.getMonth();
	var date_diff = this.getDate() - other.getDate();

	return year_diff !== 0 ? year_diff : month_diff !== 0 ? month_diff :
		date_diff;
};

/* eslint-disable no-magic-numbers */
/* format_indo: format a date into Indonesian long form.
 * Example: "Senin, 13 Februari 2016 jam 08:00 WIB"
 */
Date.prototype.format_indo = function() {
	// Get timezone data from the essential-data content tag in
	// application.html.erb.
	
	var copy = new Date(this);
	var timezone = $('#essential-data').data('timezone');
	var parsed_timezone = copy.getTimezoneOffset() / -60;

	// Diff is the difference from the user's timezone vs the parsed_timezone.
	// We need to correct for difference.
	var diff;
	if (timezone === 'WIB') {
		diff = 7 - parsed_timezone;
	} else if (timezone === 'WITA') {
		diff = 8 - parsed_timezone;
	} else if (timezone === 'WIT') {
		diff = 9 - parsed_timezone;
	} else {
		timezone = 'GMT+' + parsed_timezone;
		diff = 0;
	}

	copy.setHours(copy.getHours() + diff);

	var day = long_days[copy.getDay()];
	var date = copy.getDate();
	var month = months[copy.getMonth()];
	var year = copy.getFullYear();
	var hour = copy.getHours();
	if (hour < 10) { hour = '0' + hour; }
	var minute = copy.getMinutes();
	if (minute < 10) { minute = '0' + minute; }

	return day + ', ' + date + ' ' + month + ' ' + year + ' jam ' + hour +
		':' + minute + ' ' + timezone;
};

/* indo_go_to: format (this - other) into Indo date.
 * This is the time it takes for this to reach other.
 * Example: "23 hari 14 jam 14 menit 55 detik lagi" --> this <= other
 * or "7 hari 13 jam 0 menit 12 detik yang lalu" --> other < this
 */

Date.prototype.indo_go_to = function(other) {
	var difference = this - other;
	var text = '';
	if (difference <= 0) {
		text = 'lagi';
	} else {
		text = 'yang lalu';
	}

	difference = Math.abs(difference);

	// Seconds
	difference = Math.floor(difference / 1000);
	var seconds = difference % 60;

	// Minutes
	difference = Math.floor(difference / 60);
	var minutes = difference % 60;

	// Hours
	difference = Math.floor(difference / 60);
	var hours = difference % 24;

	// Days
	difference = Math.floor(difference / 24);
	var days = difference;

	var res = '';
	if (days !== 0) {
		res += days + ' hari ';
		res += hours + ' jam ';
		res += minutes + ' menit ';
		res += seconds + ' detik ';
	} else if (hours !== 0) {
		res += hours + ' jam ';
		res += minutes + ' menit ';
		res += seconds + ' detik ';
	} else if (minutes !== 0) {
		res += minutes + ' menit ';
		res += seconds + ' detik ';
	} else if (seconds !== 0) {
		res += seconds + ' detik ';
	}
	res += text;
	return res;
};
/* eslint-enable no-magic-numbers */
