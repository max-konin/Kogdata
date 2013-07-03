class searcher

	_url = _input = _data_container = _data = ""

	constructor: (options) ->
		options ||= {}
		_url = options.url || "/users/search"
		_input = if options.input_selector then $(input_selector) else $("#search_pattern")
		_data_container = if options.data_container_selector then $(data_container_selector) else $("#search_content")
		$.ajax {
			url: _url
			type: 'post'
			data: { s: 'earch' }
			success: (data, document, state) ->
				show_data(data)
			error: (e) ->
				console.log e
		}
	
		_input.bind 'input', (event) ->
			search this.value
			return

	search = (input) ->
		$.ajax {
			url: _url + "/" + input
			type: 'post'
			data:  { s: 'earch' }
			success: (data, document, state) ->
				show_data(data)
			error: (e) ->
				console.log e
		}
		return

	show_data = (data) ->
		_data = data
		_data_container.html _data
		return

$(document).ready () ->
	live_search = new searcher()
