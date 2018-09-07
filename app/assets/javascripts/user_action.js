$(document).ready(function() {

	$(document).on('click', '[id^="delete_session_"]', function() {
		// id attribute is expected to be of the following format: delete_session_<id>
		var words = $(this).attr("id").split("_");
		var id = words[words.length - 1];
		$('#session_table_'+id).remove();
		$.ajax({
		    method: 'DELETE',
		    url: "destroy_session",   
		    data: { authenticity_token: $('[name="csrf-token"]')[0].content, id: id},     
		    async: true,
		    success: function(result) {
				// alert(result);
		    },
		    error: function(result) {
				alert(JSON.stringify(result));
		    }
		}); 
	});

});