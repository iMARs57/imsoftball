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
	
	var footerHeight = $("footer").outerHeight();
	var navHeight = $("#navbar").outerHeight();
    $('body').css('padding-top',navHeight);
	$('#records').css('min-height',$(window).height() - navHeight - footerHeight);
	//console.log($(window).height() - navHeight - footerHeight);
	
	
	var panel_game_battingHeight = Math.max($('#table_game_battingAway').height(),$('#table_game_battingHome').height());
	$('#table_game_battingAway').height(panel_game_battingHeight);
	$('#table_game_battingHome').height(panel_game_battingHeight);
	
	var panel_game_pitchingHeight = Math.max($('#table_game_pitchingAway').height(),$('#table_game_pitchingHome').height());
	$('#table_game_pitchingAway').height(panel_game_pitchingHeight);
	$('#table_game_pitchingHome').height(panel_game_pitchingHeight);
	
	var panel_game_fieldingHeight = Math.max($('#table_game_fieldingAway').height(),$('#table_game_fieldingHome').height());
	$('#table_game_fieldingAway').height(panel_game_fieldingHeight);
	$('#table_game_fieldingHome').height(panel_game_fieldingHeight);
	
});
