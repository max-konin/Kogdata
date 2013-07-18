# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready () ->
	$("#user_update").find("input[type='file']").change () ->
		thus = this
		if typeof FileReader == undefined
			$(thus).siblings("span").find("img").attr("src", "http://placekitten.com/50/50")
		else
			reader = new FileReader()
			reader.onload = (e) ->
				$(thus).siblings("span").find("img")
					.attr("src", e.target.result)
					.width(50)
					.height(50)
				return
			reader.readAsDataURL(thus.files[0])
		return
	return

	validate_form("#user_update")
