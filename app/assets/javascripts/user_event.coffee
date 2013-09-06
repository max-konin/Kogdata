class @UserEvent extends Partial
	event_id: null
	_options =
	{
		event_elem_id: '#event'
		close_button: false
		no_ajax: false
		on_destroy: null
		on_delete: null
		on_success: null
		order_elem: null
		respone_edit_form_id: '[id^=edit_response_]'
	}

	get_options: (options) ->
		if options
			for elem of _options
				if options[elem]
					_options[elem] = options[elem]
		return

	# Load partial from server
	init: (event_id, options) ->
		if !event_id
			throw 'event id not set'
		this.event_id = event_id
		this.get_options(options)
		event_obj = this
		this.get_partial("/events/#{this.event_id}.html", _options.event_elem_id,
		{
			close_button: _options.close_button
			on_success: () ->
				event_obj.bind_form_handler()
				_options.on_success()
				return
			after_close: () ->
				if _options.on_destroy
					_options.on_destroy()
				return
		})
		return

	bind_form_handler: () ->
		if _options.no_ajax or $(_options.respone_edit_form_id).length == 0
			return

		method = $(_options.respone_edit_form_id).find('input[name=_method]').attr('value')
		if method == 'delete'
			this.bind_delete_event()
		return

	bind_delete_event: () ->
		user_event = this
		form_options =
		{
			on_success: () ->
				user_event.delete()
		}
		bind_ajax_form(_options.respone_edit_form_id, form_options)
		return

	destroy: () ->
		$(_options.event_elem_id).empty()
		if _options.on_destroy
			_options.on_destroy()
		return

	delete: () ->
		$(_options.event_elem_id).empty()
		if _options.on_delete
			_options.on_delete()
		return

	constructor: (options) ->
		this.get_options(options)
		this.bind_form_handler()
		return
