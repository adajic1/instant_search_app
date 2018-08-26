$(document).ready(function() {
	
  $('#clearAnalyticsTable').click(function (e) {
    $.ajax({
        method: 'DELETE',
        url: "destroy",   
        data: { authenticity_token: $('[name="csrf-token"]')[0].content},     
        async: true,
        success: function(result) {
          $('#analyticsContent').html(result);
        },
        error: function(result) {
          $('#analyticsContent').html("<b>Response:</b> "+result);
        }
    });  
  });
  
});