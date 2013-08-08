class @UserEvent extends Partial
	event_id: null
	_options =
	{
		event_elem_id: '#event'
		close_button: false
		on_destroy: null
		on_success: null
		order_elem: null
	}
	get_options: (options) ->
		if options
			for elem of _options
				_options[elem] = if options[elem] then options[elem] else _options[elem]
		return

	# Load partial from server
	init: (event_id, options) ->
		if !event_id
			throw 'event id not set'
		this.event_id = event_id
		this.get_options(options)
		obj = this
		this.get_partial("/events/#{this.event_id}.html", _options.event_elem_id,
		{
			close_button: _options.close_button
			on_success: _options.on_success
			after_close: () ->
				if _options.on_destroy
					_options.on_destroy()
		})
		return

	destroy: () ->
		$(_options.event_elem_id).empty()
		if _options.on_destroy
			_options.on_destroy()
		return

	constructor: (options) ->
		this.get_options(options)
		return
