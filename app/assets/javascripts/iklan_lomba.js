var iklan_title = 'LOGIKA UI 2020';
var iklan_desc = 'LOGIKA UI hadir lagi nih! Pendaftaran MIC dan MTC sedang dibuka bagi yang berminat dalam olimpiade matematika, dan ada LogiTalks yang merupakan seminar nasional dan motivation show, segera daftarkan diri kalian ya!';
var iklan_link = 'https://www.logikaui.com/';

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
