#= require ./user
#= require ../Calendar/contractor-busyness-controller

class Photograph extends User

	# Local vars for methods
	block = this.block
	block_id = this.block_id
	btn = this.btn

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

