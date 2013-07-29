# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready () ->
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

	show_calendar = () ->
		i = $('<i></i>').addClass('icon-remove pointer').on('click', () ->
			$(this).parents('.parent').first().remove()
			return
		)
		$('#right_block').empty().append(
					$('<div></div>').addClass('back_white_box parent').prepend($('<div></div>').addClass('to_right').append(i)).
					append($('<div></div>').attr('id', 'calendar'))
		)
		if initialize_calendar
			initialize_calendar()
		else
			console.log('Can\'t init calendar')
		return

	$('#calendar_button_block').click(() ->
		$('#calendar_button_block').hide()
		$('#portfolio_button_block').show()
		show_calendar()
	)
	$('#portfolio_button_block').click(() ->
		user_id = $('#portfolio_button_block').attr('user_id')
		get_partial("/users/#{user_id}.html",'#right_block',() ->
			$('#calendar_button_block').show()
			$('#portfolio_button_block').hide()
		)
		get_partial("/image/show/#{user_id}", '#bottom_block', () ->
			if carousel_init
				carousel_init()
			else
				console.log('Can\'t init carousel gallery.')
		)
	)
	return
