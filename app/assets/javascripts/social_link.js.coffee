window.user_id = $.cookie 'user_id'


$(document).ready () ->
	form_id = "#social_link_list"
	$(form_id + ' input[type=submit]').hide()
	rem_status = (form)->
		$(form).find('i[class=\'icon-repeat icon-spin\']').remove()
		return

	$(form_id).on("focusout", 'form',() ->
		$(this).find('fieldset').append($('<i></i>').addClass('icon-repeat icon-spin'))
		validate_all_fields(this, rem_status, rem_status)
		return)
	return