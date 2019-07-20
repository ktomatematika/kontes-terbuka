var iklan_title = 'OMITS 2019';
var iklan_desc = 'Halo teman-teman! pendaftaran OMITS dan MISSION sudah dibuka, bagi kalian yang berminat dalam bidang olimpiade matematika yuk segera daftarkan diri kalian!';
var iklan_link = 'https://bit.ly/daftarOMITS2019';

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
