$(document).ready(function(){

	$("#open-menu").on("click", function(){
		
		$(".navigation-mobile").fadeIn(100, function(){
			$(".navigation-mobile").addClass("mobile-open");
		});
	});

	$("#close-menu").on("click", function(){
		$(".navigation-mobile").removeClass("mobile-open");
		$(".navigation-mobile").fadeOut(250);
	})

});