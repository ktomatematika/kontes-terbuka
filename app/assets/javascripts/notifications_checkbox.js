$(document).on('turbolinks:load', function() {
	$('.notifications-checkbox').click(function() {
		$.post($('#process-change-notifications').data('path'), {
			notification_id: this.id, checked: this.checked,
		}, function() {
			alert('Notifikasi berhasil diganti!');
		});
	});
});
