#= require ../partial

class @Order extends Partial
	order_elem: null
	event_elem: null
	_options =
	{
		order_elem_id: '#orders'
		event_box_id: null
	}
	btn:
		event: '.show_event_button_block'

	bind_show_event: () ->
		$(this.btn.event).click((e) ->
			event_id = $(this).attr('event_id')
			event = new UserEvent()
			obj = this
			options =
			{
				close_button: true
				on_success: () ->
					if obj.event_elem
						obj.event_elem.destroy()

					obj.order_elem = $(e.target).parents('tr').first()
					obj.order_elem.addClass('info')

					return
				after_close: () ->
					obj.order_elem.destroy()
					return
				after_remove: () ->
					return
			}
			event.init(event_id, options)
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
		if options.parent_id
			_options.order_elem_id = options.parent_id
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
		if options
			for elem of _options
				_options[elem] = if options[elem] then options[elem] else _options[elem]

