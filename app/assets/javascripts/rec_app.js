//= require ./bootstrap-combobox/bootstrap-combobox.js

$(window).on('load resize', function(){
	
	var footerHeight = $("footer").outerHeight();
	var navHeight = $("#navbar").outerHeight();
    $('body').css('padding-top',navHeight);
	$('#rec_app').css('min-height',$(window).height() - navHeight - footerHeight);
	
	if ($(window).width() < 768){
		$('.sidebar-offcanvas').css('height', $('#rec_app').height() + 45);
		$('.sidebar-offcanvas').css('overflow', 'auto');
	}
	else{
		$('.sidebar-offcanvas').css('height', '');
		$('.sidebar-offcanvas').css('overflow', '');
	}
	
});

$(document).ready(function() {
	$('[data-toggle=offcanvas]').click(function() {
		$('.row-offcanvas').toggleClass('active');
		$("i",this).toggleClass("fa-bars fa-close");
	});
});