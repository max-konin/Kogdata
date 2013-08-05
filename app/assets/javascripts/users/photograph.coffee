#= require /Calendar/controller
#= require ./portfolio
#= require ./order

class Photograph extends Partial
	# Hide button, then raprial is loaded
	is_buttons_hide : true
	# Global class param: add close button on loaded partials.
	with_close_button : false
	# List for contain initalize objects for left, right, bottom blocks
	block =
	{
		left: null
		right: null
		bottom: null
	}
	# List for contain block id's for wich crated block objects
	block_id =
	{
		user_info : '#user_info_block'
		left: "#left_block"
		right: "#right_block"
		bottom: "#bottom_block"
	}
	# Butons for wich bindings call functions
	btn =
	{
		message: '#message_button'
		calendar: '#calendar_button'
		portfolio: '#portfolio_button'
		order: '#my_orders_button'
	}
	# Show all buttons from btn list and hide needed button
	# @param button_to_hide - id or dom object button, wich needed to hide
	hide_buttons: (button_to_hide) ->
		if this.is_buttons_hide == false
			return
		$(button).show() for name, button of btn

		if button_to_hide
			$(button_to_hide).hide()
		return

	# Init message controller
	messages: () ->
		return

	# Return info about photorgapher or client from server
	info: () ->
		if block.right
			block.right.destroy()
			block.right = null

		this.get_partial("/users/#{user_id}.html", block_id.right)
		return

	# Initialize calendar on photograph page
	# @param with_close - if true, close button will be added
	calendar: (with_close = false) ->
		# Clear left block
		if block.right != null
			block.right.destroy()
			block.right = null

		calendar = $('<div></div>').addClass('back_white_box parent').
			append($('<div></div>').attr('id', 'calendar'))
		$(block_id.right).html(calendar)

		if this.with_close_button || with_close
			this.add_close_button(calendar, Calendar)

		# Add destroy method for calendar
		if !Calendar.destroy
			Calendar.destroy = () ->
				$(block_id.right).empty()
				block.right = null
				return

		if Calendar.calendar_init
			Calendar.calendar_init()
		block.right = Calendar
		return

	# Add remove icon, and bind function destroy() object
  add_close_button: (dom_obj, object) ->
		i = $('<i></i>').addClass('icon-remove pointer').on('click', () ->
			object.destroy()
			return
		)
		i = $('<div></div>').addClass('to_right').append(i)
		$(dom_obj).prepend(i)
		return

	# Init portfolio object and load images list from server
	portfolio: () ->
		# Get user id from attr button
		user_id = $(btn.portfolio).attr('user_id')
		portfolio = new Portfolio()
		on_success = () ->
			# Clear bottom block controller
			if block.bottom != null
				block.bottom.destroy()
			block.bottom = portfolio
			return
		options =
		{
			on_success: on_success
			parent_id: block_id.bottom
		}
		portfolio.init(user_id, options)
		return

	# Init order object for orders list and load orders form server
	orders: () ->
		# Get user id from attr button
		user_id = $(btn.order).attr('user_id')
		order = new Order()
		on_success = () ->
			# Clear bottom block controller
			if block.right != null
				block.right.destroy()
			block.right = order
			return

		options =
		{
			on_success: on_success()
			parent_id: block_id.right
		}
		order.init(user_id, options)
		return

	# Bind functions for buttons on photograph page
	bind_buttons_events: () ->
		obj = this
		$(btn.calendar).click(() ->
			# Clear bottom block for more comfortalbe view calendar
			if block.bottom != null
				block.bottom.destroy()
				block.bottom = null
			obj.calendar()
			return
		)

		$(btn.message).click(() ->
			obj.messages()
			return
		)

		$(btn.portfolio).click(() ->
			obj.info()
			obj.portfolio()
		)

		$(btn.order).click(() ->
			if block.bottom
				block.bottom.destroy()
				block.bottom = null
			obj.orders()
		)
		return

	constructor: () ->
		return

window.photograph = new Photograph
$(document).ready () ->
	window.photograph.bind_buttons_events()

