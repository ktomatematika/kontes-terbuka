var REFRESH_TIME = 1000;

function update_regularly() {
	// home#index contest details, @ home.js
	fill_home_text();

	// contests#show time remaining, enable contest @ contests_show.js
	fill_contest_text();

	// contests#show add rules to long submissions @ submissions_validator.js
	validate_long_submissions();
}

$(document).ready(update_regularly);
setInterval(update_regularly, REFRESH_TIME);
