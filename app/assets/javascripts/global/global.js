function articleTemplateInsert(insert_where, article_id, article_description, article_content) {
	var template = $("#article_template").html();
	template=template.replace(new RegExp('<ID>', 'g'), article_id);
	$(insert_where).prepend(template);
	$("#article_description_"+article_id).html(article_description);
	$("#article_id_"+article_id).html(article_id);
	$("#article_content_"+article_id).html(article_content);
}

String.prototype.isEmpty = function () {
	return (this.length===0 || !this.trim());
};
