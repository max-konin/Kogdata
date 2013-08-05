#= require jquery.elastislide
#= require ../partial

class @Portfolio extends Partial
	_options =
	{
		parent_id: null
		carousel_id : '#carousel'
		image_popover_id: '#image_gallery_popover'
	}
	# Bind popover on clock image to show image on full page
	bind_portfolio_image_popover: () ->
		$(_options.carousel_id).on('click', 'a', () ->
			elem = $('<div></div>').addClass('parent').attr('id', _options.image_popover_id.substr(1))
			img = $('<img>').attr('src', $(this).attr('data-preview'))
			$(elem).append(img)
			$('body').append(elem)
			$(_options.image_popover_id).click (e) ->
				$(e.target).remove()
				return
			return
		)
		return

	# Initialize portfoliio: load html partial with images list from srver
	init: (user_id, options) ->
		if !user_id
			throw 'Can\'t init Portfoliio without user id'
		if options.parent_id
			_options.parent_id = options.parent_id
		obj = this
		this.get_partial("/image/show/#{user_id}.html", _options.parent_id, {on_success : () ->
			options.on_success()
			if $(_options.carousel_id).elastislide
				$(_options.carousel_id).elastislide()
				obj.bind_portfolio_image_popover()
			else
				throw 'Can\'t find elastislide initilazer'
		})
		return

	destroy: () ->
		# If popover showed, but destroy will be init
		if $(_options.image_popover_id).length
			$(_options.image_popover_id).remove()
		$(_options.parent_id).empty()
		return

		constructor: (options) ->
		if options
			for elem of _options
				_options[elem] = if options[elem] then options[elem] else _options[elem]
		return