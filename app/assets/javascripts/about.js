$(document).ready(function() {
	for (var i = 0; i < data_panitia.length; i++) {
		var panitia = data_panitia[i];

		var title_string = '<h3>' + panitia.name + '</h3>';

		var list_string = '<ul>';
		for (var j = 0; j < panitia.list.length; j++) {
			list_string += '<li>';
			list_string += panitia.list[j];
			list_string += '</li>';
		}
		list_string += '</ul>';

		var image_string = 'asdf';

		$('#daftar-panitia').append(
				'<div class="row">'
				+ '<div class="col-sm-8">'
				+ title_string + list_string + '</div>'
				+ '<div class="col-sm-4">'
				+ $('#about-us-pics').data(panitia.photo)
				+ '</div></div>');
	}
});
