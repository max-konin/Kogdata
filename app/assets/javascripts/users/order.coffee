#= require ../partial
#= require ../user_event

class @Order extends Partial
	order_elem: null
	event_elem: null
	_options =
	{
		order_elem_id: '#orders'
		event_box_id: null
		event_elem_id: "#event"
	}
	btn:
		event: '.show_event_button_block'

	get_options: (options) ->
		if options
			for elem of _options
				_options[elem] = if options[elem] then options[elem] else _options[elem]
		return
	# Bind event click on parent elem and looking for event button click
	bind_show_event: () ->
		obj = this
		$(_options.order_elem_id).on('click', this.btn.event, (e) ->
			# Get event id from button attr
			event_id = $(this).attr('event_id')

			# Init options for Event object
			options =
			{
				event_elem_id: _options.event_elem_id
				close_button: true
				on_success: () ->
					# Select item in orders list
					obj.order_elem = $(e.target).parents('tr').first()
					obj.order_elem.addClass('info')
					return
				on_destroy: () ->
					# Unselect item in orders list
					obj.order_elem.removeClass('info')
					obj.event_elem = null
					return
				after_remove: () ->
					return
			}
			event = new UserEvent(options)
			if obj.event_elem
				obj.event_elem.destroy()
			obj.event_elem = event

			event.init(event_id)
		)
		return

	bind_show_message = () ->
		$('.table').on('click', 'button[data-target=#messageModal]' , () ->
			user_id = $(this).attr('user_id')
			user_name = $('#user_' + user_id).text()
			$('#messageModal .user_name').html(user_name)
			# Change action to needed user, by changed id in action
			acttion = $('#messageModal form').attr('action')
			acttion = acttion.substring(0, acttion.lastIndexOf('=') + 1) + user_id
			$('#messageModal form').attr('action', acttion)
			return
		)
		return

	# Load partial with list orders from server and bind event listener on needed buttons
	init: (user_id, options) ->
		this.get_options(options)
		obj = this
		this.get_partial("/users/#{user_id}/responses.html", _options.order_elem_id,{on_success: () ->
			if options.on_success
				options.on_success()
			obj.bind_show_event()
			bind_show_message()
			return
		})
		return


	destroy: () ->
		if this.event_elem
			this.event_elem.destroy()
		$(_options.order_elem_id).empty()
		return

	constructor: (options) ->
		this.get_options(options)

