@validate_all_fields = (form_id, on_valid) ->
	if form_id == null
		console.log "Error: in send_data form_id is null"
		return false
	path = $(form_id).attr('action') #+ '/validate'
	obj = new Object
	collection = $(form_id).find(' input[type!=submit][type!=image][type!=hidden]')
	$(collection).each(
		(i,elem) ->
			obj_property_name = $(elem).attr('name')
			obj_property_name = obj_property_name.match(/(\w+)\[(\w+)\]/)
			obj_name = obj_property_name[1]
			obj_field = obj_property_name[2]
			obj_val = $(elem).val()
			if i == 0
				obj = new Object
				obj[obj_name] = new Object
			obj[obj_name][obj_field] = obj_val
			return
	)
	method = $(form_id).find('input[name=_method]').val()
	method = if method then method else 'post'
	$.ajax {
		type: 'POST'
		url: path
		dataType: 'json'
		utf8: "&#x2713;"
		method: method
		data: obj
		success: (response) ->
			if typeof response.redirect_to != 'undefined'
				document.location.href = response.redirect_to
			result = JSON.parse response.div_contents.body
			errors = undefined
			$(form_id).find('ul[class = errors_list]').remove()
			if typeof result.errors != 'undefined'
				errors = result.errors
				$(collection).each((i, elem) ->
					obj_property_name = $(elem).attr('name')
					obj_field = obj_property_name.match(/(\w+)\[(\w+)\]/)[2]
					show_errors(errors[obj_field], elem)
				)
			else
				if result.success == 'yes'
					if typeof on_valid == 'undefined'
						str_id = $(form_id).attr('id')
						document.getElementById(str_id.substring(1)).submit()
					else
						on_valid(form_id)

			$(form_id).find('input[type=submit]').attr('disabled', false)
			return
		error: (XMLHttpRequest, textStatus, errorThrown) ->
			console.log "Error: " + errorThrown
			return
	}
	return

@validate_one_field = (form, field) ->
	elem_name = $(field).attr('name')
	path = $(form).attr('action') + '/validate/'
	$.ajax {
		type: 'POST'
		url: path + elem_name.match(/\w+(?=\])/)[0]
		dataType: 'json'
		utf8: "&#x2713;"
		data: eval(elem_name.replace(/(\w+)\[(\w+)\]/, "data={$1:{$2:'" + ($(field).val()) + "'}}"))
		success: (response) ->
			result = JSON.parse response.div_contents.body
			errors = undefined
			$(field).next('ul[class = errors_list]').remove()
			if typeof result.errors != 'undefined'
				errors = result.errors
				field_name = $(field).attr('name')
				field_name = field_name.match(/\w+(?=\])/)[0]
				show_errors(errors[field_name], field)
			return
		error: (XMLHttpRequest, textStatus, errorThrown) ->
			console.log "Error: " + errorThrown
			return
	}
	return

@validate_form = (form) ->
	$(form).on("submit",() ->
		$(form).find('input[type=submit]').attr('disabled', true)
		validate_all_fields(form)
		return false
	)
	$(form).on('focusout', 'input[type!=submit][type!=image]', () ->
		validate_one_field(form, this)
	)
	return