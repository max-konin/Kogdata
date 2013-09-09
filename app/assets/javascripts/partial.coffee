###
Partial - public class wich contain basic method for load partials from server
###
class @Partial

	###
	get_partial function, wich return content from url in parent elem
	@param url - path where will be taken content
	@param parent - parent elem, wich will be cleared and fill returned content
	@param options - extended options
	| on_success() - callback function, called then data returned
	| close_button (true|false) - show or not close button
	| after_close() - function called after close box
	| fit_partial{elem, bottom_spacing} - object bottom element as to which level the height of the paftial
	###
	get_partial: (url, parent, options) ->

		partial_obj = this

		if typeof url != 'string' or typeof parent == 'undefined'
			console.log('One of params not passed.')
			return
		if typeof options == 'undefined'
			options = new Object()
		if typeof options.close_button == 'undefined'
			options.close_button = false

		onAjaxSuccess = (data, status) ->
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
				$(parent).find(' > div').prepend($('<div></div>').addClass('to_right').append(i))
			$(parent).find(' > div').addClass('parent')

			if options.fit_partial
				options.fit_partial.elem =  $(parent).find('.parent').first()
				partial_obj.fit_block(options)

			if options.on_success
				options.on_success()
			return
		data = if options.data then options.data else new Object()
		# Add salt to prevent 304 status - not modified
		sec = new Date()
		data.__salt = sec.getMinutes() + '' + sec.getSeconds() + '' + sec.getMilliseconds()

		$.get(url, data, onAjaxSuccess);

		return

	fit_block: (options) ->
		elem = $(options.fit_partial.elem)
		if !elem
			return
		#TODO: Add max height. if viewport is one column and betwen elem and footer some block, fitting incorrect
		#TODO: Bind func on resize
		bottom = $(options.fit_partial.bottom_elem).offset().top
		partial_top = elem.offset().top
		bottom_spacing = if options.fit_partial.bottom_spacing >= 0 then options.fit_partial.bottom_spacing else 20

		elem.outerHeight(bottom - partial_top - bottom_spacing)

		return

	###
  table_paginator allow to paginate table parent by list_length elements pages
  @param parent - table DOM element or id
  @param list_length - count items on one page

  @return DOM elem - block of pagination to append in needed place
	###
	table_paginator: (parent, list_length = 10) ->
		if list_length <= 1
			list_length = 2
		prev = $('<a href="#"></a>').append('<i class="icon-chevron-left"></i>')
		prev.hide()
		next = $('<a href="#"></a>').append('<i class="icon-chevron-right"></i>')
		first = $('<a href="#"></a>').append('<i class="icon-backward"></i>')
		first.hide()
		last = $('<a href="#"></a>').append('<i class="icon-forward"></i>')
		number_wrap = $('<span></span>').addClass('elem')
		current_page = 1
		count_page = Math.ceil($(parent).find('tbody tr').length / list_length)
		if count_page <= 1
			return null
		if count_page < 3
			last.hide()

		show_page = (old_page, page_num) ->
			elements = $(parent).find('tbody tr')
			# Hide elements from old page
			if old_page > 0
				# Hide old elements
				elements.slice((old_page - 1) * list_length, old_page * list_length).hide()
			#Show needed elements
			elements.slice((page_num - 1) * list_length, page_num * list_length).show()
			number_wrap.html(page_num)
			return
		# Bind prev button click
		prev.on('click', () ->
			if current_page <= 1
				current_page = 1

			show_page(current_page, --current_page)

			next.show()
			if count_page - current_page > 1
				last.show()

			if current_page < 3
				first.hide()
				if current_page == 1
					prev.hide()

			return false
		)
		# Bind first button click
		first.on('click', () ->
			show_page(current_page, current_page = 1)

			if current_page < count_page
				next.show()
				if count_page - current_page > 1
					last.show()

			first.hide()
			prev.hide()

			return false
		)
		# Bind next button click
		next.on('click', () ->
			if current_page >= count_page
				current_page = count_page

			show_page(current_page, ++current_page)

			prev.show()
			if current_page > 2
				first.show()

			if count_page - current_page < 2
				last.hide()
				if current_page == count_page
					next.hide()

			return false
		)
		# Bind last button click
		last.on('click', () ->
			show_page(current_page, current_page = count_page)

			if current_page <= count_page
				prev.show()
				if current_page > 2
					first.show()

			last.hide()
			next.hide()

			return false
		)
		# Generate paginator block
		pagnator_elem = $('<div></div>').addClass('paginator').
			append($('<span class="elem"></span>').append(first)).
			append($('<span class="elem"></span>').append(prev)).
			append(number_wrap).
			append($('<span class="elem"></span>').append(next)).
			append($('<span class="elem"></span>').append(last))
		$(parent).find('tbody tr').hide()
		show_page(0, current_page)
		return pagnator_elem