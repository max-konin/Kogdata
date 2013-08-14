#= require ../partial
#= require ../validation

###
# User edit class for binding fuctions on form and various method
# affected after change information
###
class UserEdit extends Partial
	order_elem: null
	event_elem: null
	_options =
	{
		form_parent_id: null
		form_id: '#user_update'
		social_links_block_id: '#social_link_list'
	}

	get_options: (options) ->
		if options
			for elem of _options
				if options[elem]
					_options[elem] = options[elem]
		return

	###
  # bind function for show preview image near input file
	###
	bind_show_preview: (form_id) ->
		$(form_id).find("input[type='file']").change () ->
		thus = this
		if typeof FileReader == undefined
			$(thus).siblings("img").attr("src", "http://placekitten.com/50/50")
		else
			reader = new FileReader()
			reader.onload = (e) ->
				$(thus).siblings("img")
				.attr("src", e.target.result)
				.width(50)
				.height(50)
				return
			reader.readAsDataURL(thus.files[0])
		return

	update_page_data: () ->

		return

	###
  # Binding event on form upadte_user
  # bind
	###
	bind_form_event: () ->
		on_success = ()->

			return
		form_options = {
			on_success: on_success
		}
		validate_form(_options.form_id, form_options)
		this.bind_show_event(_options.form_id)
		return

	init: (options) ->
		this.get_options(options)
		user_edit = this
		this.get_partial("/users/edit.html", _options.form_parent_id,{on_success: () ->
			if options.on_success
				options.on_success()
			user_edit.bind_form_event()
			return
		})
		return

	#TODO: Update information in user page after change data.

	constructor: (options) ->
		this.get_options(options)