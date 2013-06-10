###image_uploader = Object.create(Object)
image_uploader.prototype.images = []
image_uploader.prototype.html_of_object = "full in init"
image_uploader.prototype.selector = "div.uploadImage:visible"
# Select all object by selector
image_uploader.prototype.select_all = () ->
	$(selector)
# Select last object by selector
image_uploader.prototype.select_last = () ->
	$(selector + ":last")
# Select input in last object by selector
image_uploader.prototype.select_last_input = () ->
	$(selector + ":last input")
# Function to catch change in input
image_uploader.prototype.on_change = (e) ->
	if select_last_input().val().length != 0
		reader = new FileReader()
		reader.onload = (e) ->
			select_last.find("div.image img")
				.attr("src", e.target.result)
				.width(50)
				.height(50)
		reader.readAsDataURL(select_last_input()[0].files[0])
		select_last().after html_of_object
		select_last_input().change on_change
		return
	if select_all().size() != 1
		select_last().hide()
	return
# Init Function
image_uploader.init = () ->
	image_uploader.prototype.html_of_object = select_last()[0].outerHTML
	image_uploader.prototype.images = select_all()
	for image in images
		image.find("input").change on_change
	return
###
delete_image = () ->
	thus = this
	id = thus.id
	$.ajax {
		url: "/image/delete/" + id,
		type: "DELETE",
		success: () ->
			thus.parent().remove()
		error: () ->
			console.log "Something went wrong!"
	}
	return

upload_image = () ->
	thus = this
	if(thus.value.lenght == 0)
		return
	$.ajax {
		url: "/image/bind",
		type: "POST",
		data: { image: thus.files[0] },
		success: () ->
			html = $("li.image")[0].outerHTML
			$("li.image:last").after html
			$("li.image:last").find(".deleteImage").click delete_image
			reader = new FileReader()
			reader.onload (e) ->
				$("li.image:last").find("img")
					.attr("src", e.target.result)
					.width(50)
					.height(50)
			reader.readAsDataURL(thus.files[0])
		error: () ->
			console.log "Something went wrong!"
	}
	return

$(document).ready (e) ->
	$("#uploadImage").click upload_image
	$(".deleteImage").click delete_image
	return
