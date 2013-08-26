#= require ../partial

###
# Object of response list in own user page
###
class @ResponseList extends Partial
	_options =
	{
		response_list_id: '#responses'
		fit_partial: null
		on_destroy: null
		on_success: null
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
  # Init UserEvent object for show event, and create absolute popover block if it's not set
	###
	bind_show_gallery: () ->
		event_list_obj = this
		$(_options.event_list_id).on('click', this.btn.events, (e) ->
			# Get event id from button attr
			event_id = $(this).attr('event_id')
			if !event_id
				event_id = $(e.target).html().trim()

			if event_list_obj.response_list
				event_list_obj.response_list.destroy()
				event_list_obj.response_list = null

			event_list_obj.prepend_popover_window({
				parent_id: _options.event_list_id
				elem_id: _options.event_elem_id
			})

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
			event = new UserEvent(options)
			if event_list_obj.event_elem
				event_list_obj.event_elem.destroy()
			event_list_obj.event_elem = event

			event.init(event_id)
			return false
		)
		return

	bind_message_popover: () ->
		#TODO: add message popover
		return



	# Load partial with list orders from server and bind event listener on needed buttons
	init: (event_id, options) ->
		this.get_options(options)
		event_list = this
		this.get_partial("/events/#{event_id}/responses.html", _options.response_list_id,{
			close_button: true
			on_success: () ->
				if _options.on_success
					_options.on_success()
				#event_list.bind_show_event()
				return
			on_destroy: _options.on_destroy
		#fit_partial: _options.fit_partial
		})
		return


	destroy: () ->
		if _options.on_destroy
			_options.on_destroy()
		$(_options.response_list_id).empty()

		return

	constructor: (options) ->
		this.get_options(options)



