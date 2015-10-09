// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

/*
var ReadyandResize = function(){
		
		var navHeight = $("#navbar").outerHeight();
        $('body').css('padding-top',navHeight);
		
		//var winWidth = $(window).width();
		//var winHeight = $(window).height();
		
};
	
$(document).ready(ReadyandResize);
$(window).resize(ReadyandResize);

*/
$(window).on('load resize', function(){
	var navHeight = $("#navbar").outerHeight();
    $('body').css('padding-top',navHeight);
	
	
	var panel_game_battingHeight = Math.max($('#panel_game_battingAway').height(),$('#panel_game_battingHome').height());
	$('#panel_game_battingAway').height(panel_game_battingHeight);
	$('#panel_game_battingHome').height(panel_game_battingHeight);
	
});