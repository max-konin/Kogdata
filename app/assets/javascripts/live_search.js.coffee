class searcher

	_url = _input = _data_container = _checkboxes = _data = ""
	_page_position = _again = 0

	_request = undefined
	_request_data = undefined

	_default_options = {
		url: "/users/search"
		input_selector: "#search_pattern"
		data_container_selector: "#search_content"
		checkbox_photograph: "#search_photograph"
		checkbox_client: "#search_client"
	}

	constructor: (options) ->
		options ||= {}
		for option of _default_options
			options[option] ||= _default_options[option]
		_url = options.url
		_input = $(options.input_selector)
		_data_container = $(options.data_container_selector)
		_checkboxes = [ $(options.checkbox_photograph)[0], $(options.checkbox_client)[0] ]
		send_ajax show_data
	
		_input.bind 'input', (event) ->
			search()
			return
	
		for checkbox in _checkboxes
			$(checkbox).change (event) ->
				send_ajax show_data

		$(document).on 'scroll', (e) ->
			???

	search = () ->
		send_ajax show_data
		return

	send_ajax = (success) ->
		_request_data = {
			input: _input.val() || ""
			contractor: if _checkboxes[0].checked then 1 else 0
			client: if _checkboxes[1].checked then 1 else 0
			again: _again
		}
		not _request || _request.readyState == 4 || _request.abort("New request. Drop this away.")
		_request = $.ajax {
			url: _url
			type: 'post'
			data: _request_data
			success: if typeof success == 'function' then success else (d) -> console.log d
			error: (e) ->
				console.log e
			complete: () ->
				_request = undefined
		}

	show_data = (data) ->
		_data = data
		_data_container.html _data
		return

$(document).ready () ->
	live_search = new searcher()
