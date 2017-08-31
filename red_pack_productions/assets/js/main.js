var firstLoad = true;
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "Oktober", "November", "December"];

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

	// Full Calendar
	$("#contact-calendar").fullCalendar({
		weekends: false,
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

















