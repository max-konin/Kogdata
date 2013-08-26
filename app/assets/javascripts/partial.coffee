###
# Partial - public class wich contain basic method for load partials from server
###
class @Partial

	###
	# get_partial function, wich return content from url in parent elem
	# @param url - path where will be taken content
	# @param parent - parent elem, wich will be cleared and fill returned content
	# @param options - extended options
	# | on_success() - callback function, called then data returned
	# | close_button (true|false) - show or not close button
	# | after_close() - function called after close box
	# | fit_partial{elem, bottom_spacing} - object bottom element as to which level the height of the paftial
	###
	get_partial: (url, parent, options) ->

		if typeof url != 'string' or typeof parent == 'undefined'
			console.log('One of params not passed.')
			return
		if typeof options == 'undefined'
			options = new Object()
		if typeof options.close_button == 'undefined'
			options.close_button = false

		onAjaxSuccess = (data) ->
			result = if typeof data == 'string' then data else data.div_contents.body
			$(parent).html(result)

			if options.close_button
				i = $('<i></i>').addClass('icon-remove pointer').on('click', () ->
					$(this).parents('.parent').first().remove()
					if options.on_destroy
						options.on_destroy()
					if options.after_close
						options.after_close()
					return
				)
				$(parent).find(' > div').addClass('parent').prepend($('<div></div>').addClass('to_right').append(i))

			if options.fit_partial
				this.fit_block(options)

			if options.on_success
				options.on_success()
			return
		sec = new Date()
		# Add salt to prevent 304 status - not modified
		$.get(url, {salt: sec.getMinutes() + '' + sec.getSeconds()}, onAjaxSuccess);

		return

	fit_block: (options) ->
		bottom_elem = $(options.fit_partial.elem).offset().top
		elem = $(parent).find('>').first()
		partial_top = elem.offset().top
		bottom_spacing = if options.fit_partial.bottom_spacing >= 0 then options.fit_partial.bottom_spacing else 20
		elem.outerHeight(bottom_elem - partial_top - bottom_spacing)

		return