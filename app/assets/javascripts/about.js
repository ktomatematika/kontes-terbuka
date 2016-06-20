$(document).ready(function () {
	for (var i = 0; i < data_panitia.length; i++) {
		var panitia = data_panitia[i];

		var title_string = '<h3>' + panitia.name + '</h3>';
		var text_string = '<p>' + panitia.text + '</p>';
		var image_string = $('#about-us-pics').data(panitia.photo);

		$('#daftar-panitia').append(
				'<div class="row">'
				+ '<div class="col-sm-8">'
				+ title_string + text_string + '</div>'
				+ '<div class="col-sm-4">'
				+ image_string
				+ '</div></div>');
	}
});
