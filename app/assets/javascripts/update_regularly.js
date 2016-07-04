var REFRESH_TIME = 1000;

function update_regularly() {
	// home#index contest details
	fill_home_text();

	// contests#show time remaining, enable contest
	fill_contest_text();
}

$(document).ready(update_regularly);
setInterval(update_regularly, REFRESH_TIME);
