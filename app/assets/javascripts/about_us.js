// $(document).on('turbolinks:load', function() {
//   function reset_descriptions() {
//     $('.about-us-description').slideUp('fast');
//     $('.active-about-us').removeClass('active-about-us');
//   }
//   $('.about-us-description').hide();

//   $('.about-us-person').click(function() {
//     var me = $(this);
//     var deactivate = me.hasClass('active-about-us');
//     reset_descriptions();
//     if (!deactivate) {
//       me.addClass('active-about-us');
//       me.nextAll('.visible-' + window_type() + ':first')
//         .nextAll('.about-us-description:first')
//         .text(me.data('description')).slideDown('fast');
//       ga('send', 'event', 'about-us', 'view', $(this).data('name'));
//     }
//   });
// });

$(document).on('turbolinks:load', function () {
  function reset_descriptions() {
    $('.about-us-description').slideUp('fast'); 
    $('.active-about-us').removeClass('active-about-us'); 
  }

  $('.about-us-description').hide(); 
  $('.about-us-person').click(function () {
    var me = $(this); 
    var deactivate = me.hasClass('active-about-us'); 

    reset_descriptions(); 

    if (!deactivate) {
      me.addClass('active-about-us');
      var descriptionDiv = me.next('.about-us-description'); 

      if (descriptionDiv.length) {
          descriptionDiv.text(me.data('description')).slideDown('fast');        
      } 
      else {
        console.error("Description element not found for:", me);
      }

      if (typeof ga === 'function') {
        ga('send', 'event', 'about-us', 'view', me.data('name'));
      }
    }
  });
});


