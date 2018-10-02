var iklan_title = 'LM UGM 29';
var iklan_desc = 'Pendaftaran: 24 Sep - 14 Okt<br>Penyisihan: Minggu, 28 Oktober 2018<br>Final: 11 November 2018 di FMIPA UGM Yogyakarta';
var iklan_link = 'http://lmnas.fmipa.ugm.ac.id';

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
