$(document).ready(function() {
	// Configurable settings:
	var refresh_interval=800; // In milliseconds
	var instant_search_on=true; // Whether instant search is ON or OFF by default
	// --------------------------------------------------------------------------

	// Initialization
	if ($("#searchbox").length > 0) {
		var my_interval='';
		var old_value=0;
		if (instant_search_on) startInstantSearch();
		else stopInstantSearch();
	}  
  
	function submitIfNeeded() {
	    new_value = $('#searchbox').val();
	    if (old_value===0 || new_value!=old_value) {
			old_value=new_value;
			// Here goes ajax POST request with :body parameter
			$.ajax({
		        method: "POST",
		        url: "instant_search/create",
		        data: { body: new_value, authenticity_token: $('[name="csrf-token"]')[0].content},
		        async: true,
		        success: function(result) {
					if (result.length==0) result="-empty-";
					$('#result').html("<b>Response:</b> "+result);
					$('#result').css("visibility","visible");
		        },
		        error: function(result) {
					if (result.length==0) result="-empty-";
					$('#result').html("<b>Response:</b> "+JSON.stringify(result));
					$('#result').css("visibility","visible");
		        }
			});
		}
	}

	function setIsearchInfo() {
		if (instant_search_on) {
			$('#info_instant_search').css('color', 'blue');
			$('#info_instant_search').html("ON");      
			$('#note').css('visibility', 'hidden');
		} else {
			$('#info_instant_search').css('color', 'red');
			$('#info_instant_search').html("OFF");
			$('#note').css('visibility', 'visible');
		}
	}

	function startInstantSearch() {
		my_interval=setInterval(submitIfNeeded, refresh_interval);
		setIsearchInfo();
	}

	function stopInstantSearch() {
		clearInterval(my_interval);
		setIsearchInfo(); 
	}

	$('#searchbox').keypress(function (e) {
		if(e.which ==13) { // Enter is pressed
			submitIfNeeded();
		}        
	});

	$('#button_turn_on').click(function (e) {
		if (instant_search_on==false) {
			instant_search_on=true;
			startInstantSearch();
		}     
	});

	$('#button_turn_off').click(function (e) {
		if (instant_search_on==true) {
			instant_search_on=false;
			stopInstantSearch();    
		}     
	});

	$(document).on('page:load', $('#searchbox').val(''));
	
});
