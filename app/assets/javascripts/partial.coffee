# get_partial function, wich return content from url in parent elem
# @param url - path where will be taken content
# @param parent - parent elem, wich will be cleared and fill returned content
@get_partial = (url, parent, success_fn) ->

	onAjaxSuccess = (data) ->
		result = if typeof data == 'string' then data else data.div_contents.body
		$(parent).html(result)
		i = $('<i></i>').addClass('icon-remove pointer').on('click', () ->
			$(this).parents('.parent').first().remove()
			return
		)
		$(parent).find(' > div').addClass('parent').prepend($('<div></div>').addClass('to_right').append(i))
		if success_fn
			success_fn()
		return
	sec = new Date()
	$.get(url, {salt: sec.getSeconds()}, onAjaxSuccess);

	return