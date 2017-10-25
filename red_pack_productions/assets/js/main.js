var firstLoad = true;
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "Oktober", "November", "December"];

$(document).ready(function(){

	$('#hamburger-icon').click(function(){
		$(this).toggleClass('open');
	});

	$('#hamburger-icon').click(function(){
		$("header").toggleClass('header-open');
	});

	$('.nav-scroller').click(function(){
		if($("header").hasClass("header-open")){
			$("header").removeClass("header-open");
			$('#hamburger-icon').toggleClass('open');
		}
	});

	// Slick Slider
	var nextArrow = '<button type="button" class="slick-next"><span class="glyphicon glyphicon-chevron-right"></span</button>';
	var prevArrow = '<button type="button" class="slick-prev"><span class="glyphicon glyphicon-chevron-left"></span</button>';
	$(".testimonials-container").slick({
		autoplay: true,
		autoplaySpeed: 5000,
		nextArrow: nextArrow,
		prevArrow: prevArrow,
		dots: true
	});

	// Scroll Magic
	// Select all links with hashes
	$('a[href*="#"]')
		// Remove links that don't actually link to anything
		.not('[href="#"]')
		.not('[href="#0"]')
		.click(function(event) {
		// On-page links
		if (
		  location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') 
		  && 
		  location.hostname == this.hostname
		) {
		  // Figure out element to scroll to
		  var target = $(this.hash);
		  target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
		  // Does a scroll target exist?
		  if (target.length) {
		    // Only prevent default if animation is actually gonna happen
		    event.preventDefault();
		    $('html, body').animate({
		      scrollTop: target.offset().top
		    }, 1000, function() {
		      // Callback after animation
		      // Must change focus!
		      var $target = $(target);
		      $target.focus();
		      if ($target.is(":focus")) { // Checking if the target was focused
		        return false;
		      } else {
		        $target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
		        $target.focus(); // Set focus again
		      };
		    });
		  }
		}
	});

	// Soundcloud
	soundcloud.addEventListener('onPlayerReady', function(player, data) {
		player.api_play();
	});
	soundcloud.debug = true;

	// Full Calendar
	$("#contact-calendar").fullCalendar({
		dayClick: function(date, event, view){
			
			if(!$(this).hasClass("fc-disabled") && !$(this).hasClass("fc-past")){
				$(".fc-day").removeClass("fc-selected");
				$(this).addClass("fc-selected");
				$("#calendar-input").val(date.date() + "-" + months[date.month()] + "-" + date.year());
			}
			//$(this) = selected day element			
		},
		viewRender: function(view, element){

			// Initial date
			var today = new Date();
			$("#calendar-input").val(today.getDate() + "-" + months[today.getMonth()] + "-" + today.getFullYear());
			refreshView();
		}
	});

	// Hour selection
	// $(".hour").on("click", function(){
	// 	var checkbox = $(this).find("input");
	// 	if(checkbox.is(":checked")){
	// 		 checkbox.prop('checked', false);
 //        }else{
 //            checkbox.prop('checked', true);
 //        }
	// });


});

function refreshView(selectedDay){
	process_get_request("/api/dates", function(dates){
		console.log(dates);
		
		// Disable full dates
		var reservedDates = [];
		for(var i = 0; i < dates.length; i++){ 
			if(dates[i].reservedHours.length < 8){
				reservedDates.push(dates[i].reservedDate);
			}
			
		}
		$(".fc-day").each(function(key, day){
			if(findInArray(reservedDates, $(day).data("date"))){
				$(day).addClass("fc-disabled");
			}
		});
	});
}

function findInArray(arr, needle){
	var found = false;
	for(var i = 0; i < arr.length; i++){
		if(arr[i] == needle){
			found = true;
			break;
		}
	}
	return found;
}

function leadingZero(number){
	if(number < 10){
		return "0" + number;
	}else{
		return number
	}
}

function process_get_request(url, callback){
	$.ajax({
	  url: url,
	  type: 'GET',
	  fail: function(response) {
	    callback(response);
	  },
	  success: function(response){
	    callback(response);
	  }
	});
}