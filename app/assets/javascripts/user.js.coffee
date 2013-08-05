#  -require ./Calendar/controller

edit_form_validate_binding = () ->
	if $("select#user_role").val() == 'contractor'
		$("#price-div").show()
		$("#social_link_list").show()

	$("select#user_role").on('change', () ->
		if $("select#user_role").val() == 'contractor'
			$("#price-div").show('slow')
		else
			$("#price-div").hide('slow')
			$("#social_link_list").hide('slow')
			$("#user_price").val(null)
		return )

	validate_form("#user_update")

	$("#new_user, #user_update").find("input[type='file']").change () ->
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
	return

show_calendar = (options) ->
	if !options
		options = new Object()
	if typeof options.close_button != 'undefined' and options.close_button == true
		i = $('<i></i>').addClass('icon-remove pointer').on('click', () ->
			$(this).parents('.parent').first().remove()
			return
		)
		i = $('<div></div>').addClass('to_right').append(i)
	else
		i = ''
	$('#right_block').empty().append(
				$('<div></div>').addClass('back_white_box parent').prepend(i).
				append($('<div></div>').attr('id', 'calendar'))
	)

	if Calendar.calendar_init
		Calendar.calendar_init()
	else
		console.log('Can\'t init calendar')
	return

bind_portfolio_image_popover = (carusel_id) ->
	$(carusel_id).on('click', 'a', (e) ->
		elem = $('<div></div>').addClass('parent').attr('id', 'image_gallery_popover')
		img = $('<img>').attr('src', $(this).attr('data-preview'))
		$(elem).append(img)
		$('body').append(elem)
		$('#image_gallery_popover').click () ->
			$(this).remove()
			return
		return
	)
	return

bind_show_event = () ->
	$('.show_event_button_block').click(() ->
		event_id = $(this).attr('event_id')
		get_partial("/events/#{event_id}.html",'#left_block',
		{
			close_button: true
			success_fn: () ->
				$("#event_#{event_id}").addClass('info')
				return
			after_close: () ->
				$("#event_#{event_id}").removeClass('info')
				return
		})
	)
	return

bind_show_message = () ->
	$('.table').on('click', 'button[data-target=#messageModal]' , () ->
		user_id = $(this).attr('user_id')
		user_name = $('#user_' + user_id).text()
		$('#messageModal .user_name').html(user_name)
		acttion = $('#messageModal form').attr('action')
		acttion = acttion.substring(0, acttion.lastIndexOf('=') + 1) + user_id
		$('#messageModal form').attr('action', acttion)
		return
	)
	return

init_user_page = () ->

	# Button for contractor home page
	$('#my_events_button_block').click(() ->
		user_id = $('#my_events_button_block').attr('user_id')
		get_partial("/users/#{user_id}/events.html",'#left_block',{close_button: true})
	)
	# Button for contractor home page
	$('#my_orders_button_block').click(() ->
		user_id = $('#my_orders_button_block').attr('user_id')
		get_partial("/users/#{user_id}/responses.html",'#right_block',{success_fn: () ->
			$('#bottom_block').empty()
			$('#user_info_block [id$=_button_block]').show()
			$('#my_orders_button_block').hide()
			bind_show_event()
			bind_show_message()
			return
		})
	)
	# Button on contractor page for other users
	$('#calendar_button_block').click(() ->
		$('#user_info_block [id$=_button_block]').show()
		$('#calendar_button_block').hide()
		$('#bottom_block').empty()
		show_calendar({close_button: false})
	)
	# Button on contactor home page and other users then looks his page
	$('#portfolio_button_block').click(() ->
		user_id = $('#portfolio_button_block').attr('user_id')
		get_partial("/users/#{user_id}.html",'#right_block',{success_fn: () ->
			$('#user_info_block [id$=_button_block]').show()
			$('#portfolio_button_block').hide()
			$('#left_block').empty()
		})
		get_partial("/image/show/#{user_id}", '#bottom_block', {success_fn: () ->
			if $('#carousel').elastislide
				$('#carousel').elastislide()
				bind_portfolio_image_popover('#carousel')
			else
				console.log('Can\'t init carousel gallery.')
		})
	)
	# Button in home page every user for ajax send instad link follow
	$('#settings_button').click(() ->
		$('#bottom_block').empty()
		$('#left_block').empty()
		$('#user_info_block [id$=_button_block]').show()
		get_partial("/users/edit.html",'#right_block', {success_fn: () ->
			if init_social_links and edit_form_validate_binding
				edit_form_validate_binding()
				init_social_links()
			else
				console.log('Can\'t find init_social_links or edit_form_validate_binding.')
		})
		return false
	)
	return

$(document).ready () ->
	init_user_page()
	edit_form_validate_binding()
	return
