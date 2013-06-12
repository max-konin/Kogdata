###image_uploader = Object.create(null)
image_uploader.prototype = Object.create(null)
image_uploader.prototype.images = []
image_uploader.prototype.html_of_object = "full in init"
image_uploader.prototype.selector = "li.image"
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
		if typeof FileReader == undefined
			select_last.find("img").attr("src", "http://placekitten.com/50/50")
		else
			reader = new FileReader()
			reader.onload = (e) ->
				select_last().find("div.image img")
					.attr("src", e.target.result)
					.width(50)
					.height(50)
			reader.readAsDataURL(select_last_input()[0].files[0])
			select_last().after html_of_object
			select_last_input().change on_change
	if select_all().size() != 1
		select_last().hide()
	return
# Function for delete
image_uploader.prototype.on_delete = (e) ->
	
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
	if id != ""
		if not confirm "Are you sure you want delete this image?"
			return
		$.ajax {
			url: "/image/delete",
			type: "DELETE",
			data: { id: id }
			success: () ->
				$(thus).parent().remove()
			error: () ->
				console.log "Something went wrong!"
		}
	else
		$(thus).parent().remove()
	return

upload_image = () ->
	thus = this
	if(thus.value.length == 0)
		return
	html = "<li class='image'><div><img src /></div><div class='deleteImage' id>X</div></li>"
	$("#images").append html
	$("li.image:last").find(".deleteImage").attr("id", "").click delete_image
	$(thus).after thus.outerHTML
	$(thus).css { display: "none" }
	$(thus).siblings("input[type='file']").change upload_image
	if typeof FileReader == undefined
		$("li.image:last").find("img").attr("src", "http://placekitten.com/50/50")
	else
		reader = new FileReader()
		reader.onload = (e) ->
			$("li.image:last").find("img")
				.attr("src", e.target.result)
				.width(50)
				.height(50)
		reader.readAsDataURL(thus.files[0])
	return

$(document).ready (e) ->
	$("#uploadImage").change upload_image
	$(".deleteImage").click delete_image
	return
