#= require ../partial

###
# Object of response list in own user page
###
class @ResponseList extends Partial
	_options =
	{
		response_list_id: '#responses'
		fit_partial: null
		on_destroy: null
		on_success: null
	}
	btn:
		events: '.show_event_link'
		responses: '.show_responses_link'

	get_options: (options) ->
		if options
			for elem of _options
				if options[elem]
					_options[elem] = options[elem]
		return

	###
  # Init UserEvent object for show event, and create absolute popover block if it's not set
	###
	bind_show_gallery: () ->
		#TODO: add gallery popover for Portfolio object
		return

	bind_message_popover: () ->
		#TODO: add message popover
		return



	# Load partial with list orders from server and bind event listener on needed buttons
	init: (event_id, options) ->
		this.get_options(options)
		response_list = this
		this.get_partial("/events/#{event_id}/responses.html", _options.response_list_id,{
			close_button: true
			on_success: () ->
				if _options.on_success
					_options.on_success()
				#event_list.bind_show_event()
				paginator = response_list.table_paginator($(_options.response_list_id).find('table').first())
				$(_options.event_list_id).find('> div').first().append(paginator)
				return
			on_destroy: _options.on_destroy
			#fit_partial: _options.fit_partial
		})
		return


	destroy: () ->
		if _options.on_destroy
			_options.on_destroy()
		$(_options.response_list_id).empty()

		return

	constructor: (options) ->
		this.get_options(options)



