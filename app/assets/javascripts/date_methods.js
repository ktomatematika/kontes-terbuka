var now = new Date();

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

	return (year_diff != 0) ? year_diff : (month_diff != 0) ? month_diff :
		date_diff;
}

/* format_indo: format a date into Indonesian long form.
 * Example: "Senin, 13 Februari 2016 jam 08:00 WIB"
 */
Date.prototype.format_indo = function() {
	var day = long_days[this.getDay()];
	var date = this.getDate();
	var month = months[this.getMonth()];
	var year = this.getFullYear();
	var hour = this.getHours();
	if (hour < 10) { hour = '0' + hour; }
	var minute = this.getMinutes();
	if (minute < 10) { minute = '0' + minute; }
	var timezone = this.getTimezoneOffset() / -60;

	return day + ", " + date + " " + month + " " + year + " jam " + hour + 
		":" + minute + " GMT+" + timezone;
}

/* indo_go_to: format (this - other) into Indo date.
 * This is the time it takes for this to reach other.
 * Example: "23 hari 14 jam 14 menit 55 detik lagi" --> this <= other
 * or "7 hari 13 jam 0 menit 12 detik yang lalu" --> other < this
 */

Date.prototype.indo_go_to = function(other) {
	var difference = this - other;
	var text = "";
	if (difference <= 0) {
		text = "lagi";
	} else {
		text = "yang lalu";
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

	return days + " hari " + hours + " jam " + minutes + " menit " + seconds +
		" detik " + text;
}
