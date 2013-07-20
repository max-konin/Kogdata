# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready () ->
	$("#user_update").find("input[type='file']").change () ->
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
	return
