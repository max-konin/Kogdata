window.user_id = $.cookie 'user_id'


window.delete_social_link = (parent, id) ->
	$.ajax {
		type: 'POST'
		url: "/users/#{user_id}/social_links/#{id}.json"
		dataType: 'json'
		method: 'delete'
		data: {
			social_link: {
				description: $('#social_link_description').val()
				url: $('#social_link_url').val()
			}
		}
		success: (response) ->

			res = JSON.parse response.div_contents.body
			if res.result == false
				showModalDialog(res.error)
			else
				$(parent).remove()
			return
		error: (XMLHttpRequest, textStatus, errorThrown) ->
			console.log "Error: " + errorThrown
			return
	}

window.show_errors = (list, elem) ->
	if list == undefined
		return
	if list.length > 0
		ul = $("<ul></ul>").addClass('errors_list').insertAfter(elem)
		for mess in list
			ul.append($('<li></li>').html(mess))
	return

get_domain_path = (url) ->
	expr = ///^(https?://([\w-]+\.)?[\w-]+\.\w+(\.\w+)?)(?:.*)$///
	res = expr.exec(url)
	if res == null
		res
	else
		res[1]

$(document).ready () ->
	form_id = "#social_link_form"
	$(form_id).on("submit",() ->
		$(this).find('input[type=submit]').attr('disabled', true);
		$.ajax {
			type: 'POST'
			url: "/users/#{user_id}/social_links.json"
			dataType: 'json'
			data: {
				social_link: {
					description: $('#social_link_description').val()
					url: $('#social_link_url').val()
				}
			}
			success: (response) ->
				result = JSON.parse response.div_contents.body
				errors = undefined
				if typeof result.errors != 'undefined'
					errors = result.errors
				$(form_id + ' ul[class=errors_list]').remove()
				if errors != undefined
					show_errors(errors.description, "#social_link_description")
					show_errors(errors.url, "#social_link_url")
				else
					$(form_id).trigger('reset')
					div = $('<div></div>').addClass('row-fluid').attr('id', "social_link_#{result.id}")
					sp4 = $('<span></span>').addClass('span4').
						append($('<img/>').attr('src', get_domain_path(result.url) + '/favicon.ico').addClass('favicon')).
						append("\n").
						append($('<a></a>').attr('href', result.url).html(result.description))
					sp6 = $('<span></span>').addClass('span6').html(result.url)
					sp2 = $('<span></span>').addClass('span2').
						append($('<i></i>').addClass('icon-trash cursor').click(
							() ->
								delete_social_link("#social_link_#{result.id}", result.id)
						))
					div.append(sp4).append(sp6).append(sp2)
					$('#social_link_list').append(div)

				$(form_id).find('input[type=submit]').attr('disabled', false)
				return
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				console.log "Error: " + errorThrown
				return
		}
		return false)
	return