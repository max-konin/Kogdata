#= require jquery.elastislide
#= require ../partial

class @Portfolio extends Partial
	_options =
	{
		parent_id: null
		carousel_id : '#carousel'
		image_popover_id: '#image_gallery_popover'
	}
	get_options: (options) ->
		if options
			for elem of _options
				if options[elem]
					_options[elem] = options[elem]
		return
	# Bind popover on clock image to show image on full page
	bind_portfolio_image_popover: () ->
		$(_options.carousel_id).on('click', 'a', () ->
			elem = $('<div></div>').addClass('parent').attr('id', _options.image_popover_id.substr(1))
			img = $('<img>').attr('src', $(this).attr('data-preview'))
			$(elem).append(img)
			$('body').append(elem)
			$(_options.image_popover_id).click (e) ->
				if $(e.target).is('div')
					$(e.target).remove()
				return
			return false
		)
		return

	# Initialize portfoliio: load html partial with images list from srver
	init: (user_id, options) ->
		if !user_id
			throw 'Can\'t init Portfoliio without user id'
		this.get_options(options)
		obj = this
		this.get_partial("/users/#{user_id}/gallery.html", _options.parent_id, {on_success : () ->
			if options.on_success
				options.on_success()
			if $(_options.carousel_id).elastislide
				$(_options.carousel_id).elastislide({minItems: 1})
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
		this.get_options(options)
		return