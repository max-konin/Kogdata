window.user_id = $.cookie 'user_id'

@init_social_links = () ->
	div_block_id = "#social_link_list"
	$(div_block_id + ' input[type=submit]').hide()

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

	$(div_block_id).on("focusout", 'form',() ->
		value = $(this).find('input[type=text]').val()
		value = value.trim()
		id = $(this).find('input[name$=\'[id]\']').val()

		if value.length == 0
			options.method = 'delete'
			options.path = $(this).attr('action') + '/' + id
		else
			options.method = null
			options.path = null
		if value.length != 0 or id.length != 0
			validate_all_fields(this, options)
		return)
	return

$(document).ready () ->
	init_social_links()
	return