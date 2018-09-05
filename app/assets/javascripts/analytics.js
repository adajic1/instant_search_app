$(document).ready(function() {

	$('#clear_analytics_table').click(function (e) {
		$.ajax({
	        method: 'DELETE',
	        url: "destroy",   
	        data: { authenticity_token: $('[name="csrf-token"]')[0].content},     
	        async: true,
	        success: function(result) {
				$('#analytics_content').html(result);
	        },
	        error: function(result) {
				$('#analytics_content').html("<b>Error:</b> "+JSON.stringify(result));
	        }
		});  
	});
  
	$(document).on('click', '[id^="analytics_destroy_"]', function() {
		// id attribute is expected to be of the following format: analytics_destroy_<id>
    	var words = $(this).attr("id").split("_");
		var id = words[words.length - 1];
		$('#analytics_row_'+id).remove();
	    if ($('[id^="analytics_destroy_"]').length==0) 
			$('#analytics_content').html("All data cleared...");
		$.ajax({
	        method: 'DELETE',
	        url: "destroy_record",   
	        data: { authenticity_token: $('[name="csrf-token"]')[0].content, id: id},     
	        async: true,
	        success: function(result) {
				// alert(result);
	        },
	        error: function(result) {
				$('#analytics_content').html("<b>Error:</b> "+JSON.stringify(result));
	        }
	    }); 
	});
  
});