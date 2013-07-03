class searcher
	constructor: (@url, input_selector, data_container_selector) ->
		@input = $(input_selector)
		@data_container = $(data_container_selector)
		$.ajax {
			url: @url
			type: 'post'
			data: { s: 'earch' }
			success: (data, document, state) ->
				@data = data
			error: (e) ->
				console.log e
		}

		@input.on 'keypress', (event) ->
			search this.value
			return

		@input.change (event) ->
			search this.value
			return

	search = (input) ->
		$.ajax {
			url: @url + "/" + input
			type: 'post'
			data:  { s: 'earch' }
			success: (data, document, state) ->
				@data = data
			error: (e) ->
				console.log e
		}
		return

	show_data = () ->
		@data_container.html @data
		return
		
	@::__defineSetter__ "data", (value) ->
		@data = value
		show_data()
		return

window.searcher = searcher
