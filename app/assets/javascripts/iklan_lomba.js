var iklan_title = 'Try Out OSN-K Matematika SMA 2022 gammanormids';
var iklan_desc = 'Try Out OSN-K Matematika SMA 2022 yang diselenggarakan oleh gammanormids bersama KTOM untuk mempersiapkan OSN-K mendatang. Dengan mengikuti Try Out ini, kalian akan mendapatkan berbagai fasilitas dan hadiah yang menarik. Tunggu apalagi? Yuk, segera daftar!';
var iklan_link = 'https://www.instagram.com/gammanormids';

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
