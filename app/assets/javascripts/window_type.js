/* exported window_type */
function window_type() {
	var width = window.innerWidth;
	/* eslint-disable no-magic-numbers */
	if (width >= 1200) {
		return 'lg';
	} else if (width >= 992) {
		return 'md';
	} else if (width >= 768) {
		return 'sm';
	} else {
		return 'xs';
	}
}
