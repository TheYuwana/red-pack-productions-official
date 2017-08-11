$(document).ready(function(){

	$('#hamburger-icon').click(function(){
		$(this).toggleClass('open');
	});

	$('#hamburger-icon').click(function(){
		$("header").toggleClass('header-open');
	});

	// Soundcloud
	soundcloud.addEventListener('onPlayerReady', function(player, data) {
		player.api_play();
	});
	soundcloud.debug = true;

});