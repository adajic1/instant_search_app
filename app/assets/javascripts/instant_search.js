$(document).ready(function() {
  // Configurable settings:
  var refreshInterval=800; // In milliseconds
  var iSearchOn=true; // Whether instant search is ON or OFF by default
  // ------------------------------------------------------------------

  // Initialization
  if ($("#searchbox").length > 0) {
    var myInterval='';
    var oldValue=0;
    if (iSearchOn) startISearch();
    else stopISearch();
  }  
  
  function submitIfNeeded() {
    newValue = $('#searchbox').val();
    if (oldValue===0 || newValue!=oldValue) {
      oldValue=newValue;
      // Here goes ajax POST request with :body parameter
      $.ajax({
        method: "POST",
        url: "instant_search/create",
        data: { body: newValue, authenticity_token: $('[name="csrf-token"]')[0].content},
        async: true,
        success: function(result) {
          if (result.length==0) result="-empty-";
          $('#result').html("<b>Response:</b> "+result);
          $('#result').css("visibility","visible");
        },
        error: function(result) {
          if (result.length==0) result="-empty-";
          $('#result').html("<b>Response:</b> "+result);
          $('#result').css("visibility","visible");
        }
      });
    }
  }

  function setIsearchInfo() {
    if (iSearchOn) {
      $('#infoIsearch').css('color', 'blue');
      $('#infoIsearch').html("ON");      
      $('#note').css('visibility', 'hidden');
    } else {
      $('#infoIsearch').css('color', 'red');
      $('#infoIsearch').html("OFF");
      $('#note').css('visibility', 'visible');
    }
  }

  function startISearch() {
    myInterval=setInterval(submitIfNeeded, refreshInterval);
    setIsearchInfo();
  }

  function stopISearch() {
    clearInterval(myInterval);
    setIsearchInfo(); 
  }

  $('#searchbox').keypress(function (e) {
    if(e.which ==13) { // Enter is pressed
      submitIfNeeded();
    }        
  });

  $('#btnTurnOn').click(function (e) {
    if (iSearchOn==false) {
      iSearchOn=true;
      startISearch();
    }     
  });

  $('#btnTurnOff').click(function (e) {
    if (iSearchOn==true) {
      iSearchOn=false;
      stopISearch();    
    }     
  });

  $(document).on('page:load', $('#searchbox').val(''));
});
