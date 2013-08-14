#= require ../partial
#= require ../user_event

#TODO: check - work without @ and create docs
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
		event: '.show_event_button'

	get_options: (options) ->
		if options
			for elem of _options
				if options[elem]
					_options[elem] = options[elem]
		return
	# Bind event click on parent elem and looking for event button click
	bind_show_event: () ->
		order_obj = this
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
					order_obj.order_elem = $(e.target).parents('tr').first()
					order_obj.order_elem.addClass('info')
					return
				on_destroy: () ->
					# Unselect item in orders list
					order_obj.order_elem.removeClass('info')
					order_obj.event_elem = null
					return
				on_delete: () ->
					# Delete elem from orders list
					order_obj.order_elem.remove()
					order_obj.event_elem = null
					return
			}
			event = new UserEvent(options)
			if order_obj.event_elem
				order_obj.event_elem.destroy()
			order_obj.event_elem = event

			event.init(event_id)
			return
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

