#= require ../partial

###
# Object of response list in own user page
###
class @ResponseList extends Partial
	portfolio: null
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
		portfolio: '.portfolio_button'

	get_options: (options) ->
		if options
			for elem of _options
				if options[elem]
					_options[elem] = options[elem]
		return

	###
  bind_show_gallery show gallery from response list by selected user
  ###
	bind_show_gallery: () ->
		#TODO: add gallery popover for Portfolio object
		response_list = this
		$(_options.response_list_id).on('click', response_list.btn.portfolio , () ->
			# Init and append gallery in response list
			gallery = $('<div></div>').attr('id', 'gallery').addClass('modal').css({
				'top': '50%'
				'width': '100%'
				'margin-left': '-50%'
				'margin-top': '-150px'
			})
			$(_options.response_list_id).parent().append(gallery)
			# Bind resizer function
			resizer = ()->
				gl_height = gallery.height()
				gallery.css('margin-top', '-' + Math.round(gl_height / 2) + 'px')
				return
			user_id = $(this).attr('user_id')
			portfolio = new Portfolio()
			options =
			{
				parent_id: gallery
			}
			portfolio.init(user_id, options)
			gallery.on('hidden', ()->
				$(this).remove()
				return
			)
			$(window).resize(resizer)
			gallery.modal('show')
			return
		)
		return
	###
  bind_message_popover on response list
  change data in form by selected user
	###
	bind_message_popover: () ->
		$(_options.response_list_id).on('click', 'button[data-target=#messageModal]' , () ->
			user_id = $(this).attr('user_id')
			user_name = $('#user_' + user_id).text()
			$('#messageModal .user_name').html(user_name)
			acttion = $('#messageModal form').attr('action')
			acttion = acttion.substring(0, acttion.lastIndexOf('=') + 1) + user_id
			$('#messageModal form').attr('action', acttion)
			return
		)

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
				response_list.bind_show_gallery()
				response_list.bind_message_popover()
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



