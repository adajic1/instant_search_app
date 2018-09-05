$(document).ready(function() {
  
  function articleTemplateInsert(article_id, article_description, article_content) {
  	var template = $("#article_template").html();
  	template=template.replace(new RegExp('<ID>', 'g'), article_id);
  	$("#articles_list").prepend(template);
  	$("#article_description_"+article_id).html(article_description);
  	$("#article_id_"+article_id).html(article_id);
  	$("#article_content_"+article_id).html(article_content);
  }
  
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
          else {
          	var article_id = result;
          	articleTemplateInsert(article_id, $("#article_description").val(), $("#article_content").val());
            $('#new_article_form')[0].reset();            
          }
        },
        error: function(result) {
          alert(JSON.stringify(result));
        }
    });  
  });
  
  $('#clear_form_button').click(function (e) {
  	$('#new_article_form')[0].reset();
  });

  $(document).on('click', '[id^="article_destroy_"]', function() {
  	// id attribute is expected to be of the following format: article_destroy_<id>
    var words = $(this).attr("id").split("_");
    var id = words[words.length - 1];
    $('#article_span_'+id).remove();
    $.ajax({
        method: 'DELETE',
        url: "destroy_article",   
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

  $(document).on('page:load', $('#new_article_form')[0].reset());
  
  for (i = 0; i < array_of_article_ids.length; i++) {
    articleTemplateInsert(array_of_article_ids[i], 
    	                  array_of_article_descriptions[i], 
    	                  array_of_article_contents[i]);
  }
  
});