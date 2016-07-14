$(document).ready(function() {
	$('.notifications-checkbox').click(function() {
		$.post($('#process-change-notifications').data('path'), {
			id: this.id, checked: this.checked
		}, function() {
			alert('Notifikasi berhasil diganti!')
		});
	});
});
