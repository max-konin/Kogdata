# get_partial function, wich return content from url in parent elem
# @param url - path where will be taken content
# @param parent - parent elem, wich will be cleared and fill returned content
@get_partial = (url, parent) ->

	onAjaxSuccess = (data) ->
		$(parent).html(data.div_contents.body)
		i = $('<i></i>').addClass('icon-remove to_right').on('click', () ->
			$(this).parent('.parent').first().remove()
			return
		)
		$(parent).find(' > div').addClass('parent').prepend(i)
		return
	sec = new Date()
	$.get(url, {salt: sec.getSeconds()}, onAjaxSuccess);

	return