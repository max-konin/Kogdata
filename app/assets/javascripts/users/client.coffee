#= require ./user

class Client extends User

	# Local vars for methods
	block = this.block
	block_id = this.block_id
	btn = this.btn

	# Bind functions for buttons on photograph page
	bind_buttons_events: () ->
		client = this
		# Buttons on personal page
		$(btn.calendar).click(() ->
			# Clear bottom block for more comfortalbe view calendar
			if block.bottom != null
				block.bottom.destroy()
				block.bottom = null
			client.calendar()
			return
		)

		$(btn.message).click(() ->
			client.messages()
			return
		)

		$(btn.portfolio).click(() ->
			client.info()
			client.portfolio()
			return
		)

		$(btn.user_edit).click(() ->
			# Clear bottom block for more comfortalbe view edit form
			if block.bottom
				block.bottom.destroy()
				block.bottom = null
			client.user_edit()
			return false
		)
		$(btn.event).click(() ->
			if block.bottom
				block.bottom.destroy()
				block.bottom = null
			client.events()
			return
		)

		return



	constructor: () ->
		return

window.client = new Client
$(document).ready () ->
	window.client.bind_buttons_events()
	if $('#calendar').length
		window.client.calendar()

