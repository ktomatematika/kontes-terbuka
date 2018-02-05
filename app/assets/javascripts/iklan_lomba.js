var iklan_title = '';
var iklan_desc = 'Tunggu kerjasama kami dengan kontes berikutnya!';
var iklan_link = '';

$(document).on('turbolinks:load', function() {
	if ($('#iklan-lomba').length !== 0) {
		$('#judul-iklan')[0].innerHTML = iklan_title;
		$('#desc-iklan')[0].innerHTML = iklan_desc;
		if (iklan_title === '') {
			$('#iklan-lomba img').hide();
		} else {
			$('#iklan-lomba img').prop('alt', iklan_title);
		}

		$('#iklan-lomba').click(function() {
			window.open(iklan_link, '_blank');
		});
	}
});
