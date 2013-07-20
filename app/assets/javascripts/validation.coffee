@validate_all_fields = (form_id, on_valid, on_invalid) ->
	if form_id == null
		console.log "Error: in send_data form_id is null"
		return false
	$(form_id).find('ul[class = errors_list]').remove()
	path = $(form_id).attr('action') #+ '/validate'
	obj = new Object
	collection = $(form_id).find(' input[type!=submit][type!=image]')
	collection = $(collection).map(
		(i,elem) ->
			obj_property_name = $(elem).attr('name')
			obj_property_name = obj_property_name.match(/(\w+)\[(\w+)\]/)
			if obj_property_name == null
				return
			obj_name = obj_property_name[1]
			obj_field = obj_property_name[2]
			obj_val = $(elem).val()
			if typeof obj[obj_name] == 'undefined'
				obj[obj_name] = new Object
			obj[obj_name][obj_field] = obj_val
			return this
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
			if typeof result.errors != 'undefined'
				errors = result.errors
				$(collection).each((i, elem) ->
					obj_property_name = $(elem).attr('name')
					obj_field = obj_property_name.match(/(\w+)\[(\w+)\]/)[2]
					show_errors(errors[obj_field], elem)
				)
				if typeof on_invalid != 'undefined'
					on_invalid(form_id, result)
			else
				if result.success == 'yes'
					if typeof on_valid == 'undefined'
						str_id = $(form_id).attr('id')
						document.getElementById(str_id.substring(1)).submit()
					else
						$(collection).each((i, elem) ->
							obj_property_name = $(elem).attr('name')
							obj_property_name = obj_property_name.match(/(\w+)\[(\w+)\]/)
							obj_name = obj_property_name[1]
							obj_field = obj_property_name[2]
							$(elem).val(result[obj_name][obj_field])
							return)
						on_valid(form_id, result)

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

@show_errors = (list, elem) ->
	if list == undefined
		return
	if list.length > 0
		ul = $("<ul></ul>").addClass('errors_list').insertAfter(elem)
		for mess in list
			ul.append($('<li></li>').html(mess))
	return