$(document).ready(function() {
	
  $('#save_article').click(function (e) {
  	var formData = new FormData($('#new_article_form')[0]);
  	formData.append('authenticity_token', $('[name="csrf-token"]')[0].content);
    $.ajax({
        method: 'POST',
        url: "create",   
        data: formData,     
        async: true,
        processData: false,
        contentType: false,
        success: function(result) {
          if (result.match("^ERROR:"))
          	alert(result);
          else
            $('#new_article_form')[0].reset();
        },
        error: function(result) {
          alert(result);
        }
    });  
  });
  
  $('#clear_form_button').click(function (e) {
  	$('#new_article_form')[0].reset();
  });

});