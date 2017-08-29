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

	/*
		Calendar selectors
		fc-today
		fc-day
		fc-future
		fc-past

		data-date = 2017-01-24
	*/

	// Full Calendar
	$("#contact-calendar").fullCalendar({
		dayClick: function(date, event, view){
			console.log(date);
			//$(this) = selected day element
			$(this).css('background-color', 'red');
		},
		viewRender: function(view, element){

			// Fetch reserved dates
			process_get_request("/api/dates", function(dates){
				console.log(dates);

				// Current day
				var today = new Date();
				var currentDays = refreshDays(today.getMonth(), today.getFullYear());

				// $(".fc-day").each(function(key, day){
				// 	console.log($(day).data("date"));
				// 	console.log(findInArray(currentDays, $(day).data("date")));
				// });
			});
		}
	});
});

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

function refreshDays(month, year){
	var date = new Date(year, month, 1);
	var days = [];
	while (date.getMonth() === month) {
		var current = new Date(date);
		date.setDate(current.getDate() + 1);
		days.push(current.getFullYear() + "-" + leadingZero(current.getMonth() + 1) + "-" + leadingZero(current.getDate()));
	}
	return days;
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

















