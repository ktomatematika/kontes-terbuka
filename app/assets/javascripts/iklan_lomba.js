var iklan_title = '';
var iklan_desc = 'Tunggu kerjasama kami dengan berbagai olimpiade ' +
'matematika di Indonesia yang berikutnya!';

$(document).ready(function() {
	if ($('#iklan-lomba').length !== 0) {
		$('#judul-iklan')[0].innerHTML = iklan_title;
		$('#desc-iklan')[0].innerHTML = iklan_desc;
		$('#iklan-lomba img').prop('alt', iklan_title);
	}
});
