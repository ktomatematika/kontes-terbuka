var iklan_title = 'MCF ITB 2022';
var iklan_desc = 'MCF ITB hadir dengan beberapa kompetisi seperti ITBMO, Hi-MMC, MMC, DSC, dan ACC, serta ada pula webinar yang pastinya bakal menarik banget bagi kamu yang ingin lebih mendalami berbagai cabang dalam matematika. Tunggu apalagi, yuk segera daftarkan diri kamu!';
var iklan_link = 'https://mcf-itb-2022.com/';

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
