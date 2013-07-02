class searcher
	constructor: (@url, @selector ### should select input ###) ->
		$.ajax {
			url: url
			type: POST
			success: (data, document, state) ->
				data = JSON.parse data
				@data = parse_tree(data)
			error: (e) ->
				console.log e
		}
		
		$(document).ready () ->
			$(@selector).change (input) ->
				search(input)

	search = (input) ->
		

	parse_tree = (data) ->
		for elem in data
			for char in elem
				@data[char] ||= NULL
