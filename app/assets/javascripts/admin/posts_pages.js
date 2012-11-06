var editor;
var resource_form;
var resource_body_element;
var auto_save_url = null;
var auto_save_timer;

$(function() {
	if (document.getElementById('editor')) {
		initializeEditor('editor');

		//editor.getSession().on('change', updatePreview);
		editor.getSession().on('change', beginAutoSave);
		
		updatePreview();
	}
	
	$('input[type="text"].title').blur(generateSlug);

	$('input[type="button"][data-action="save"]').click(save);
	$('input[type="button"][data-action="unpublish"]').click(unpublish);
	$('input[type="button"][data-action="save_and_publish"]').click(saveAndPublish);
	$('input[type="button"][data-action="destroy"]').click(destroy);
});

function generateSlug(e) {
	title_input = $(e.target);
	slug_input = $('input[type="text"].slug').first();
	
	if (slug_input.val() == '') {
		slug_input.val(title_input.val().trim().toLowerCase().replace(/\s+/g, '-').replace(/[^A-Za-z0-9\-]/g, ''));
	}
}
	
function initializeEditor(element_id) {
	editor = ace.edit(element_id);
	editor.getSession().setUseWrapMode(true);
		
	var MarkdownMode = require("ace/mode/markdown").Mode;
	editor.getSession().setMode(new MarkdownMode());
}

function updatePreview() {
	if ($('#ResourcePreview_Body')) {
		//$('#ResourcePreview_Body').html();
	}
}

	
function save(e) {
	resource_body_element.val(editor.getValue());
	$('input#resource_action').val('save');
	resource_form.submit();
}
	
function unpublish(e) {
	resource_body_element.val(editor.getValue());
	$('input#resource_action').val('unpublish');
	resource_form.submit();
}
	
function saveAndPublish(e) {
	resource_body_element.val(editor.getValue());
	$('input#resource_action').val('publish');
	resource_form.submit();
}

function destroy(e) {
	if (confirm("Are you sure you want to destroy this item?")) {
		$.ajax({
  		  url: resource_form.attr('action'),
		  type: 'post',
		  data: {
			  '_method': 'DELETE',
			  'authenticity_token': resource_form.find('input[type=hidden][name=authenticity_token]').first().attr('value')
		  },
		  dataType: 'json',
		  success: function(data, textStatus, jqXHR) {
			  window.location = data.redirect_to;
		  }
		});
	}
}

function beginAutoSave() {
	window.clearTimeout(auto_save_timer);

	auto_save_timer = window.setTimeout(autoSave, 2500);
}	

function autoSave() {
	if (auto_save_url != null) {
		resource_body_element.val(editor.getValue());
		$('input#resource_action').val('autosave');

		$.ajax({
			url: auto_save_url,
			type: 'post',
			data: resource_form.serialize(),
			dataType: 'json',
			success: function(data, textStatus, jqXHR) {
				$('#save_notice').show();

				window.setTimeout(function() {
					$('#save_notice').fadeOut('fast');
				}, 2000);
			}
		});
	}
}