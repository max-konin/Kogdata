class searcher

	_url = _input = _data_container = _checkboxes = _data = ""

	_request = undefined

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
		send_ajax _url, { s: 'earch' }, show_data
	
		_input.bind 'input', (event) ->
			search this.value
			return

		_c = _checkboxes
	
		for checkbox in _c
			$(checkbox).change (event) ->
				send_ajax _url, { checkboxes: [ _c[0].checked, _c[1].checked ] }, show_data

	search = (input) ->
		send_ajax "#{_url}/#{input}", { s: 'earch' }, show_data
		return

	send_ajax = (url, data, success) ->
		not _request || _request.abort()
		_request = $.ajax {
			url: url
			type: 'post'
			data: data
			success: success
			error: console.log
		}

	show_data = (data) ->
		_data = data
		_data_container.html _data
		return

$(document).ready () ->
	live_search = new searcher()
