var iklan_title = 'LMNAS UGM';
var iklan_desc = 'Lomba Matematika Nasional ke-27 UGM kembali hadir ' +
	'dengan total hadiah 34 juta Rupiah. Babak penyisihan dilaksanakan ' +
	'serentak di 22 titik wilayah di Indonesia pada tanggal 30 Oktober 2016.'
var iklan_link = 'http://lmnas.fmipa.ugm.ac.id';

$(document).ready(function() {
	if ($('#iklan-lomba').length !== 0) {
		$('#judul-iklan')[0].innerHTML = iklan_title;
		$('#desc-iklan')[0].innerHTML = iklan_desc;
		$('#iklan-lomba img').prop('alt', iklan_title);

		$('#iklan-lomba').click(function() {
			window.open(iklan_link, '_blank');
		});
	}
});
