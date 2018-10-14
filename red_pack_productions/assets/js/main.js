var firstLoad = true;
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "Oktober", "November", "December"];
var map;
var shareButton = {};

$(document).ready(function(){

	$('#hamburger-icon').click(function(){
		$(this).toggleClass('open');
		$("header").toggleClass('header-open');

		if($(this).hasClass("open")){
			$(".language-container-mobile").fadeIn(300);
		}else{
			$(".language-container-mobile").fadeOut(300);
		}
	});

	$('.nav-scroller').click(function(){
		if($("header").hasClass("header-open")){
			$("header").removeClass("header-open");
			$('#hamburger-icon').toggleClass('open');
		}
	});

	// Share button
	shareButton = new ShareButton({
	  ui: {
            buttonText: $(".share-button").data("label")
        },
        networks: {
            googlePlus: { enabled: true },
            twitter: { enabled: true },
            facebook: { enabled: true },
            pinterest: { enabled: false },
            reddit: { enabled: false },
            linkedin: { enabled: false },
            whatsapp: { enabled: true },
            email: { enabled: false }
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
				$("#calendar-input").val(leadingZero(date.date()) + "-" + leadingZero((date.month()+1)) + "-" + date.year());
			}			
		},
		viewRender: function(view, element){

			// Initial date
			var today = new Date();

			// Set initial planing date to today when empty, else higlight the selected date
			if($("#calendar-input").val() == ""){
				$("#calendar-input").val(today.getDate() + "-" + months[today.getMonth()] + "-" + today.getFullYear());
			}else{
				// Produces dd, mm, yy
				var dateArr = $("#calendar-input").val().split("-");
				var formattedDate = dateArr[2] + "-" + dateArr[1] + "-" + dateArr[0];
				
				// Set selected if found
				$("[data-date='"+formattedDate+"']").addClass("fc-selected");
			}

			refreshView();
		}
	});

	// Init map
	if($("#front-maps").length){
		initMap();
	}

	// Hour selection
	if($(".hour").length){
		$(".hour").each(function(){
			var checkbox = $(this).find("input");
			if(checkbox.is(":checked")){
				$(this).toggleClass("hour-selected");
			}
		});
	}
	$(".hour").on("click", function(){
		var checkbox = $(this).find("input");
		if(checkbox.is(":checked")){
			$(this).removeClass("hour-selected");
			checkbox.prop('checked', false);
        }else{
        	$(this).toggleClass("hour-selected");
            checkbox.prop('checked', true);
        }
	});

});

function initMap() {

	var redpackproductions = {lat: 51.8740939, lng: 4.6184794}; 
	map = new google.maps.Map(document.getElementById('front-maps'), {
	  zoom: 16,
	  center: redpackproductions,
	  scrollwheel: false
	});

	// Center Marker
	var marker = new google.maps.Marker({
	  position: redpackproductions,
	  map: map
	});

}

function refreshView(selectedDay){
	process_get_request("/api/dates", function(dates){
		//console.log(dates);
		
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





// FILTER SELECTOR

$(function() {
	$('select').change(function() {
  	var _this = $(this);
  	if ( _this.val() == 0 )
        $('.product-item').css("opacity","1").css("display", "inline");
 
    else {
    	$('.product-item').hide();
    	$('.product-item.' + _this.val()).css("display","inline").css("opacity","1");
    }
  });
});


// SHOPPING BASKET
$(document).ready(function(){
  sb_set_basket_events();
});

function sb_set_basket_events(){

  // Set Icon open and close
  $(".basket-icon").click(function(){
		$(this).parent().toggleClass("open-basket");
  });
  
  // Set add to basket events
  $(".basket-add").click(function(){
   sb_add_to_basket(
    $(this).data("basket-product-id"),
    $(this).data("basket-product-name"),
    $(this).data("basket-product-price")
   ); 
  });
  
  // Set remove product from basket
  $(".remove-product").click(function(){
    sb_remove_from_basket($(this));
  });
  
  // Set on change for prouct amounts
  $(".basket-products input").change(function(){
    sb_sum_total();
  });
	
}

function sb_add_to_basket(pid, name, price){
  if(sb_product_not_exist(pid)){
    var shortName = name;
    if(name.length > 20){
      shortName = name.substring(25, 0) + "...";
    }
    $(".basket-products ul").append(
      $("<li>").append(
        $("<span>", {"class": "remove-product"}).click(function(){
          sb_remove_from_basket($(this));
        }),
        $("<input>", {"type": "number", "min": "1"}).val(1).change(function(){
          sb_sum_total();
        }),
        shortName,
        $("<span>", {"class": "amount"}).text("\u20AC " + price)
      ).data("price", price).data("pid", pid)
    );
  }
  sb_sum_total();
  sb_update_basket_amount();
}

function sb_product_not_exist(pid){
  var notFound = true;
  $(".basket-products ul").find("li").each(function(){
    if($(this).data("pid") == pid){
      var val = Number($(this).find("input").val()) + 1;
      $(this).find("input").val(val);
      notFound = false;
      return false;
    }else{
      notFound = true;
    }
  });
  return notFound;
}

function sb_remove_from_basket(product){
  $(product).parent().remove();
  sb_sum_total();
  sb_update_basket_amount();
}

function sb_sum_total(){
  var total = 0;
  $(".basket-products ul").find("li").each(function(){
    var amount = Number($(this).find("input").val());
    total = total + (amount * Number($(this).data("price")));
  });
  $(".basket-total-amount").text("\u20AC " + total);
}

function sb_update_basket_amount(){
  $(".basket-count p").text($(".basket-products ul").find("li").length);
}


