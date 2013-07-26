class searcher

	_url = _url_message = _input = _data_container = _checkboxes = _data = ""
	_page_position = _again = _offset = 0

	_request = undefined
	_request_data = undefined
	_better_request_data = undefined

	_default_options = {
		url: "/users/search"
		url_message: '/users/show_modal'
		input_selector: "#search_pattern"
		data_container_selector: "#search_content"
		checkbox_photograph: "#search_photograph"
		checkbox_client: "#search_client"
		offset: 50
	}

	constructor: (options) ->
		options ||= {}
		for option of _default_options
			options[option] ||= _default_options[option]
		_url = options.url
		_url_message = options.url_message
		_input = $(options.input_selector)
		_data_container = $(options.data_container_selector)
		_checkboxes = [ $(options.checkbox_photograph)[0], $(options.checkbox_client)[0] ]
		_offset = options.offset
		#send_ajax show_data

		_input.bind 'input', (event) ->
			search()
			return

		$(options.data_container_selector).on('click', 'button[data-target=#messageModal]' , () ->
			user_id = $(this).attr('user_id')
			user_name = $('#user_' + user_id).text()
			$('#messageModal .user_name').html(user_name)
			acttion = $('#messageModal form').attr('action')
			acttion = acttion.substring(0, acttion.lastIndexOf('=') + 1) + user_id
			$('#messageModal form').attr('action', acttion)
			return
		)

		for checkbox in _checkboxes
			$(checkbox).change (event) ->
				send_ajax show_data

		$(window).on('scroll', (event) ->
			_position = _data_container.height() + _data_container.position().top
			_position_view = this.innerHeight + this.pageYOffset
			if _position - _offset <= _position_view
				search_deeper()
			return
		)

	get_message_dialog = () ->
		div_id = $(this).attr('data-target')
		user_id = div_id.substring(div_id.indexOf('_') + 1)
		if $(div_id + ' i[class="icon-spin icon-refresh"]')[0]
			$.ajax({
				url: _url_message + '/' + user_id
				type: 'post'
				data: {user_id: user_id}
				success: (data) -> $(div_id).html(data); return;
				error: (e) ->
					console.log e.readyState
					return
			})
		return

	search = () ->
		send_ajax show_data
		return

	search_deeper = () ->
		_better_request_data = {
			input: _input.val() || ""
			contractor: if _checkboxes[0].checked then 1 else 0
			client: if _checkboxes[1].checked then 1 else 0
			again: 1
		}
		append_data = (data) ->
			_data += data
			_data_container.append data
			return
		send_ajax(append_data)
		return


	send_ajax = (success) ->
		_request_data = _better_request_data || {
			input: _input.val() || ""
			contractor: if _checkboxes[0].checked then 1 else 0
			client: if _checkboxes[1].checked then 1 else 0
		}
		not _request || _request.readyState == 4 || _request.abort("New request. Drop this away.")
		_request = $.ajax {
			url: _url
			type: 'post'
			data: _request_data
			success: if typeof success == 'function' then success else (d) -> console.log d; return
			error: (e) ->
				console.log e
				return
			complete: () ->
				return
		}
		return true

	show_data = (data) ->
		_data = data
		_data_container.html _data
		return

	

$(document).ready () ->
	live_search = new searcher()

