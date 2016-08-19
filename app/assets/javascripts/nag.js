$(document).ready(function() {
	$('#close-nag').click(function() {
		$('#nag-overlay').fadeOut();
		$.post($(this).data('href'));
	});

	var lock_seconds = 3;
	var nag_btn = $('#close-nag');
	nag_btn.text(lock_seconds);
	nag_btn.attr('disabled', true);

	function nag_lock_tick() {
		lock_seconds--;
		if (lock_seconds > 0) {
			nag_btn.text(lock_seconds);
			nag_btn.attr('disabled', true);
		} else {
			nag_btn.text('Tutup');
			nag_btn.attr('disabled', false);
		}
	}
	window.setInterval(nag_lock_tick, 1000);
});
