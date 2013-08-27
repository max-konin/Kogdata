#= require ../partial
#= require ./response_list

###
# Object of event list in own user page
###
class @EventList extends Partial

	###
	# Object of event elem UserEdit class
	###
	event_elem: null

	###
	# DOM elem of selected item in EventList
	###
	event_list_elem: null

	###
	# Object of response list ResponseList class
	###
	response_list: null

	_options =
	{
		# Parent id elem for this class
		event_list_id: '#event_list'
		# id of child elem UserEvent class
		event_elem_id: '#event'
		# id of child elem ResponseList class
		response_list_id: '#responses'
		fit_partial: null
	}
	btn:
		events: '.show_event_link'
		responses: '.show_responses_link'

	get_options: (options) ->
		if options
			for elem of _options
				if options[elem]
					_options[elem] = options[elem]
		return

	###
	# This method create parent popover elem for content from server response
	# @param options - parameters for function
	# | elem_id - div id, wich will be created in  parent_id
	# | parent_id - id parent element
	# | parameters from _popover_opt for overwriting
	###
	prepend_popover_window: (options) ->
		if !$( options.parent_id).length
			throw 'Can\'t insert element in undefined'

		if $( options.elem_id).length
			return

		_popover_opt = {
			'height': 'auto'
			'width' : '340px'
			'z-index' : 1
			'position' : 'absolute'
		}
		# Overwrite parameters in _popover_opt by options
		for elem of _popover_opt
			if options[elem]
				_popover_opt[elem] = options[elem]

		div_elem = $('<div></div>').attr('id', options.elem_id.substring(1)).css(_popover_opt)

		$(options.parent_id).prepend(div_elem)
		#TODO: bind resizer method on window
		if document.width <= 767 # Width from bootstrap
			if options.offset_elem
				offset_elem = $(options.offset_elem).offset()
				offset_div = offset_elem

				if offset_elem.left + div_elem.outerWidth() > document.width
					offset_div.left = document.width - 20 - div_elem.outerWidth()

				if offset_elem.top + div_elem.outerHeight() > document.height
					offset_div.top = document.height - 20 - div_elem.outerHeight()

				div_elem.offset(offset_div)
		else
			parent_pos = $(options.parent_id).offset()
			div_elem.offset({
				left: parent_pos.left + $(options.parent_id).outerWidth() + 20
				top: parent_pos.top
			})

		return

	###
	# Init UserEvent object for show event
	###
	bind_show_event: () ->
		event_list_obj = this
		$(_options.event_list_id).on('click', this.btn.events, (e) ->
			# Get event id from button attr
			event_id = $(this).attr('event_id')
			if !event_id
				event_id = $(e.target).html().trim()

			# Init options for Event object
			options =
			{
				event_elem_id: _options.event_elem_id
				close_button: true
				on_success: () ->
					# Select item in orders list
					event_list_obj.event_list_elem = $(e.target).parents('tr').first()
					event_list_obj.event_list_elem.addClass('info')
					return
				on_destroy: () ->
					# Unselect item in orders list
					event_list_obj.event_list_elem.removeClass('info')
					event_list_obj.event_list_elem = null
					event_list_obj.event_elem = null
					$(_options.event_elem_id).remove()
					return
				on_delete: () ->
					# Delete elem from orders list
					event_list_obj.event_list_elem.remove()
					event_list_obj.event_list_elem = null
					event_list_obj.event_elem = null
					$(_options.event_elem_id).remove()
					return
			}

			if event_list_obj.response_list
				event_list_obj.response_list.destroy()
				event_list_obj.response_list = null

			if event_list_obj.event_elem
				event_list_obj.event_elem.destroy()

			event_list_obj.prepend_popover_window({
				parent_id: _options.event_list_id
				elem_id: _options.event_elem_id
				offset_elem: e.target
			})

			event = new UserEvent(options)
			event_list_obj.event_elem = event
			event.init(event_id)
			return false
		)
		return

	###
	# Init UserEvent object for show reponse list
	###
	bind_show_responses: () ->
		event_list_obj = this
		$(_options.event_list_id).on('click', this.btn.responses, (e) ->
			# Get event id from button attr
			event_id = $(this).attr('event_id')
			if !event_id
				td = $(e.target).parent('tr').
				event_id = $(e.target).html().trim()

			# Init options for Event object
			options =
			{
				event_elem_id: _options.event_elem_id
				close_button: true
				on_success: () ->
					# Select item in orders list
					event_list_obj.event_list_elem = $(e.target).parents('tr').first()
					event_list_obj.event_list_elem.addClass('info')
					return
				on_destroy: () ->
					# Unselect item in orders list
					event_list_obj.event_list_elem.removeClass('info')
					event_list_obj.event_list_elem = null
					event_list_obj.response_list = null
					$(_options.response_list_id).remove()
					return
				on_delete: () ->
					# Delete elem from orders list
					event_list_obj.event_list_elem.remove()
					event_list_obj.event_elem = null
					return
			}

			if event_list_obj.event_elem
				event_list_obj.event_elem.destroy()
				event_list_obj.event_elem = null

			if event_list_obj.response_list
				event_list_obj.response_list.destroy()
				event_list_obj.response_list = null

			event_list_obj.prepend_popover_window({
				parent_id: _options.event_list_id
				elem_id: _options.response_list_id
				'width': '540px'
				offset_elem: e.target
			})

			respone_list = new ResponseList(options)
			event_list_obj.response_list = respone_list

			respone_list.init(event_id)
			return false
		)
		return

	# Load partial with list orders from server and bind event listener on needed buttons
	init: (user_id, options) ->
		this.get_options(options)
		event_list = this
		this.get_partial("/users/#{user_id}/events.html", _options.event_list_id,{
			on_success: () ->
				if options.on_success
					options.on_success()
				event_list.bind_show_event()
				event_list.bind_show_responses()
				paginator = event_list.table_paginator($(_options.event_list_id).find('table').first())
				$(_options.event_list_id).find('> div').first().append(paginator)
				return
			#fit_partial: _options.fit_partial
		})
		return

	# Function wich call before destroy object for correctly work application
	# Than EventList is destring, calling destroy methods to child objects
	destroy: () ->
		if this.event_elem
			this.event_elem.destroy()

		if this.response_list
			this.response_list.destroy()

		return

	constructor: (options) ->
		this.get_options(options)


