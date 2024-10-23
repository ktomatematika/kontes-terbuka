var iklan_title = 'Mathematics Challenge 2024';
var iklan_desc = 'Mathematics Challenge 2024 diselenggarakan oleh HIMATIKA ULM. Olimpiade Matematika untuk seluruh siswa-siswi SMP se-Kalimantan dan SMA se-Indonesia. Segera daftarkan dirimu!';
var iklan_link = 'https://mathematicschallenge.com';

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
