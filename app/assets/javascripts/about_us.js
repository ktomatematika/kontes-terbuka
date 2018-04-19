$(document).on('turbolinks:load', function() {
  var MD_COLUMNS = 3;
  var SM_COLUMNS = 2;
  var BOOTSTRAP_ROW = 12;

  var MD_ROW = BOOTSTRAP_ROW / MD_COLUMNS;
  var SM_ROW = BOOTSTRAP_ROW / SM_COLUMNS;

  function add_data(array, tag) {
    var len_round_md = MD_COLUMNS *
      Math.ceil(array.length / MD_COLUMNS);

    for (var i = 0; i < len_round_md; i++) {
      var about_us_obj = array[i];

      // Add about us objects if not undefined
      if (typeof about_us_obj !== 'undefined') {
        tag.append(
          '<div class="col-md-' + MD_ROW + ' col-sm-' + SM_ROW +
          ' about-us-person "' +
          'data-name="' + about_us_obj.name + '" ' +
          'data-description="' + about_us_obj.description + '">' +
          $('#about-us-pics').data(about_us_obj.image) +
          '<h3>' + about_us_obj.name + '</h3>' +
          '</div>');
      }

      // Clearfix + add placeholders for about us description
      var clearfix_classes = 'clearfix visible-xs';
      if (i % SM_COLUMNS === SM_COLUMNS - 1) {
        clearfix_classes += ' visible-sm';
      }
      if (i % MD_COLUMNS === MD_COLUMNS - 1) {
        clearfix_classes += ' visible-md visible-lg';
      }
      tag.append(
        '<div class="' + clearfix_classes + '"></div>' +
        '<div class="about-us-description"></div>');
    }
  }

  add_data(about_us_data, $('#daftar-panitia'));
  add_data(alumni_data, $('#alumni-panitia'));

  function reset_descriptions() {
    $('.about-us-description').slideUp('fast');
    $('.active-about-us').removeClass('active-about-us');
  }
  $('.about-us-description').hide();

  $('.about-us-person').click(function() {
    var me = $(this);
    var deactivate = me.hasClass('active-about-us');
    reset_descriptions();
    if (!deactivate) {
      me.addClass('active-about-us');
      me.nextAll('.visible-' + window_type() + ':first')
        .nextAll('.about-us-description:first')
        .text(me.data('description')).slideDown('fast');
      ga('send', 'event', 'about-us', 'view', $(this).data('name'));
    }
  });
});
