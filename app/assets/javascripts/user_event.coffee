class UserEvent extends Partial
	event_id: null
	options:
		event_elem_id: '#event'
		close_button: false
		on_destroy: null

	# Load partial from server
	init: (event_id, options) ->
		if !event_id
			throw 'event id not set'

		if options
			for elem of this.options
				this.options[elem] = if options[elem] then options[elem] else this.options[elem]

		this.event_id = event_id

		if parent_id
			this.options.event_elem_id = parent_id

		this.get_partial("/events/#{this.event_id}.html", this.options.event_elem_id,
		{
			close_button: this.options.close_button
			on_success: options.on_success

			after_close: () ->
				this.order_elem.destroy()
				return
		})
		return

	destroy: () ->
		$(this.options.event_elem_id).empty()
		if this.options.on_destroy
			this.options.on_destroy()
		return

	constructor: (options) ->
		if options
			for elem of this.options
				this.options[elem] = if options[elem] then options[elem] else this.options[elem]
