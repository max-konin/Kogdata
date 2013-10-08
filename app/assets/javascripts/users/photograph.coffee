#= require ./user
#= require Calendar/Controllers/contractor-busyness-controller

class Photograph extends User

	# Local vars for methods
	block = this.block
	block_id = this.block_id
	btn = this.btn

	#add radiogroup to select calendar type only for contractor
	on_success: () ->
		$('button[name=options]').click () ->
			unless $(this).hasClass('active')
				window.Calendar.clear()
				if $(this).hasClass('my-calendar-option')
					window.Calendar = new contractorBusynessController
					Calendar.calendar_init()
				if $(this).hasClass('orders-option')
					window.Calendar = new window.showAllEventsController
					Calendar.calendar_init()
		return

	calendar: () ->
		super
		this.get_partial('/calendar/get_contractor_navigation.html','#navigation', {on_success: @on_success})
		return

	# Bind functions for buttons on photograph page
	bind_buttons_events: () ->
		photograph = this

		# Buttons on personal page
		$(btn.calendar).click(() ->
			# Clear bottom block for more comfortalbe view calendar
			if block.bottom != null
				block.bottom.destroy()
				block.bottom = null
			photograph.calendar()
			return
		)

		$(btn.message).click(() ->
			photograph.messages()
			return
		)

		$(btn.portfolio).click(() ->
			photograph.info()
			photograph.portfolio()
			return
		)

		$(btn.order).click(() ->
			# Clear bottom block for more comfortalbe view orders
			if block.bottom
				block.bottom.destroy()
				block.bottom = null
			photograph.orders()
			return
		)

		$(btn.user_edit).click(() ->
			# Clear bottom block for more comfortalbe view edit form
			if block.bottom
				block.bottom.destroy()
				block.bottom = null
			photograph.user_edit()
			return false
		)
		return



	constructor: () ->
		return

window.photograph = new Photograph
$(document).ready () ->
	window.photograph.bind_buttons_events()

