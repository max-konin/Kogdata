window.user_id = $.cookie 'user_id'


$(document).ready () ->
	form_id = "#social_link_list"
	$(form_id + ' input[type=submit]').hide()

	status_start = (form) ->
		$(form).find('fieldset').append($('<i></i>').addClass('icon-repeat icon-spin'))
		return
	status_end = (form) ->
		$(form).find('i[class=\'icon-repeat icon-spin\']').remove()
		return

	options = {
		status_start: status_start
		status_end: status_end
	}

	$(form_id).on("focusout", 'form',() ->

		validate_all_fields(this, options)
		return)
	return