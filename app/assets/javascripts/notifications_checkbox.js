$(document).on('turbolinks:load', function() {
  $('.notifications-checkbox').click(function(e) {
    var target = e.target;

    if (target.checked) {
      $.post($(target).data('create'), { notification_id: this.id }, function() {
        alert('Notifikasi berhasil dibuat!');
      })
    } else {
      $.ajax({
        url: $(target).data('delete'),
        data: { notification_id: this.id },
        type: 'DELETE',
        success: function() {
          alert('Notifikasi berhasil dibuang!');
        }
      });
    }
  });
});
