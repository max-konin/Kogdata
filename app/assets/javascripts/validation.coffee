# Show error on page for user if some happens
alert_on_error = () ->
	if $('#status_alert').length
		err = $('#status_alert')
		err.empty()
	else
		err = $('<div></div>').attr('id', 'status_alert').addClass('alert alert-error').html('Возникла ошибка')
	err.prepend($('<button></button>').addClass('close').attr('data-dismiss': 'alert').html('&times'))
	$('body > .container').first().prepend(err)
	return

###
validate_all_fields
public function to validate all fiels in form
except inputs: submit, image, file
This function send fileds named by type like 'user[name]'
@param form_id - First parameter obect - form or it's id
@param options - Second parameter options - Object of extended parameters:
  | collection - array of jQuery collention objects for send
  | clear_errors(form_id) - for clear custom errors
  | show_errors(elem, message) - for custom errors messages
  | status_start(form_id) - for display custom wait status
  | on_success(result) - external callback function.
  | status_end(form_id) - for hide custom wait status
  | default_submit [true, false] - for call default submit on success
  | disable_submit = true [true, false] - for call default submit on success
	| path - path to send
in success recieve:
| redirect_to - path to redirect page
| errors - associative array (Object) of string error messages
| success - string,if 'yes' - on server changes are success.
###
@validate_all_fields = (form_id, options) ->
	if form_id == null
		console.log "Error: in send_data form_id is null"
		return false
	if typeof options == 'undefined'
		options = new Object()

	# Default submit is disabled
	if typeof options.disable_submit == 'undefined'
		options.disable_submit = true

	# Call custom clear errors function
	if options.clear_errors
		options.clear_errors(form_id)
	else
		# default erros list remove from all form
		$(form_id).find('ul[class = errors_list]').remove()

	if options.status_start
		options.status_start(form_id)
	# set path there request will be sent
	path = if options.path then options.path else $(form_id).attr('action')
	#set collection wich be parsed and sent
	collection = if options.collection then options.collection else
		$(form_id).find(' input[type!=submit][type!=image][type!=file], select')
	#TODO: update code for ajax sending files by FormData(); http://labdes.ru/zagruzka-kartinok-na-server
	data_obj = new Object
	collection = $(collection).map(
		(i,elem) ->
			obj_property_name = $(elem).attr('name')
			obj_property_name = obj_property_name.match(/(\w+)\[(\w+)\]/)
			if obj_property_name == null
				return
			obj_name = obj_property_name[1]
			obj_field = obj_property_name[2]
			obj_val = $(elem).val()
			if typeof data_obj[obj_name] == 'undefined'
				data_obj[obj_name] = new Object
			data_obj[obj_name][obj_field] = obj_val
			return this
	)
	# Get method from options or form
	method = if options.method then options.method else $(form_id).find('input[name=_method]').val()
	# Method by default 'post'
	method = if method then method else 'post'

	# Disable submit button
	if options.disable_submit
		$(form_id).find('input[type=submit]').attr('disabled', true)

	$.ajax {
		type: 'POST'
		url: path
		dataType: 'json'
		utf8: "&#x2713;"
		method: method
		data: data_obj
		success: (response) ->
			if options.status_end
				options.status_end(form_id)
			# If need to redirect
			if typeof response.redirect_to != 'undefined'
				document.location.href = response.redirect_to

			result = JSON.parse response.div_contents.body

			# if vaildation errors
			if typeof result.errors != 'undefined'
				errors = result.errors
				$(collection).each((i, elem) ->
					obj_property_name = $(elem).attr('name')
					obj_field = obj_property_name.match(/(\w+)\[(\w+)\]/)[2]
					# Show custom errors or default
					if options.show_errors
						options.show_errors(elem, errors[obj_field])
					else
						show_errors(elem, errors[obj_field])
				)
			else
				if result.success == 'yes'
					# Update collenction by new values, returned from server
					$(collection).each((i, elem) ->
						obj_property_name = $(elem).attr('name')
						obj_property_name = obj_property_name.match(/(\w+)\[(\w+)\]/)
						obj_name = obj_property_name[1]
						obj_field = obj_property_name[2]
						if result[obj_name] and result[obj_name][obj_field]
							$(elem).val(result[obj_name][obj_field])
						return)

					# Callback external function
					if options.on_success
						options.on_success(result)

					# Init default submit
					if options.default_submit == true
						str_id = $(form_id).attr('id')
						if str_id
							document.getElementById(str_id.substring(1)).submit()
						else
							console.log 'Form id undefined. Please set id for init default submit'
			# Enable submit button
			if options.disable_submit
				$(form_id).find('input[type=submit]').attr('disabled', false)
			return
		error: (XMLHttpRequest, textStatus, errorThrown) ->
			console.log "Error: " + errorThrown
			alert_on_error()
			return
	}
	return

###
# validate_one_field
# Send one field on server and return result, vaild this field, or not
# Display errors if field is invalid
# @param form - form id or jQuery Object
# @param field - id of field, or jQuery Object
# @param options - Object of extended parameters
# | clear_errors(form_id) - for clear custom errors
# | show_errors(elem, message) - for custom errors messages
# | status_start(form_id) - for display custom wait status
# | status_end(form_id) - for hide custom wait status
###
@validate_one_field = (form, field, options) ->

	if typeof options == 'undefined'
		options = new Object()

	elem_name = $(field).attr('name')
	path = if options.path then options.path else $(form).attr('action') + '/validate/' + elem_name.match(/\w+(?=\])/)[0]

	if options.clear_errors
		clear_errors(form)
	else
		$(field).next('ul[class = errors_list]').remove()

	if options.status_start
		options.status_start(form, field)

	$.ajax {
		type: 'POST'
		url: path
		dataType: 'json'
		utf8: "&#x2713;"
		data: eval(elem_name.replace(/(\w+)\[(\w+)\]/, "data={$1:{$2:'" + ($(field).val()) + "'}}"))
		success: (response) ->
			result = JSON.parse response.div_contents.body
			if options.status_end
				options.status_end(form, field)

			if typeof result.errors != 'undefined'
				errors = result.errors
				field_name = $(field).attr('name')
				field_name = field_name.match(/\w+(?=\])/)[0]
				if options.show_errors
					options.show_errors(field, errors[field_name])
				else
					show_errors(field, errors[field_name])
			return
		error: (XMLHttpRequest, textStatus, errorThrown) ->
			console.log "Error: " + errorThrown
			alert_on_error()
			return
	}
	return

###
# validate_form
# Validate each field by 'validate_one_field' function and send this form on submit
# @param form - form id or jQuery Object
# @param options - parameters for 'validate_all_fields' function
# | field_event - extend parameter, for change state to start validate function
# @param to_field_options - parameters for 'validate_one_field' option
###
@validate_form = (form, options, to_field_options) ->
	if !$(form)[0]
		return
	if typeof options == 'undefined'
		options = Object()

	$(form).on("submit",() ->
		$(form).find('input[type=submit]').attr('disabled', true)
		validate_all_fields(form, options)
		return false
	)
	if !options.field_event
		options.field_event = 'focusout'

	$(form).on(options.field_event, 'input[type!=submit][type!=image][type!=file], select', () ->
		validate_one_field(form, this, to_field_options)
	)
	return

###
# send_form
# Validate all fields by sending ajax validate_all_fields function
# @param form - form id or jQuery Object
# @param options - parameters for 'validate_all_fields' function
###
@bind_ajax_form = (form, options) ->
	if !$(form)[0]
		return
	if typeof options == 'undefined'
		options = Object()
	###
  can cteate default spin status for form
  in options add id selector, where in form will be showed spin wait status such social links
	if !options.status_start
		options.status_start = (form) ->

			return

	if !options.status_end
		options.status_end = (form) ->

			return
	###
	$(form).on("submit",() ->
		validate_all_fields(form, options)
		return false
	)
	return


# TODO: Create default errors messages such popover on each input / select elem
# http://bootstrap-ru.com/javascript.php#popovers | Live demo
@show_errors = (elem, list) ->
	if list == undefined
		return
	if list.length > 0
		ul = $("<ul></ul>").addClass('errors_list').insertAfter(elem)
		for mess in list
			ul.append($('<li></li>').html(mess))
	return
