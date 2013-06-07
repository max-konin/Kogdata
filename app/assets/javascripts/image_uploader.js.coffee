image_uploader = Object.create(Object)
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

uploadImageDiv = "div.uploadImage"
uploadImageDivLast = uploadImageDiv + ":last"
lastInputUploadImage = uploadImageDivLast + " input"
uploadImageHtml = "t"

job = (e) ->
	if $(lastInputUploadImage).val().length != 0
		reader = new FileReader()
		reader.onload = (e) ->
			$(uploadImageDivLast).find("div.image img")
				.attr("src", e.target.result)
				.width(50)
				.height(50)
		reader.readAsDataURL($(lastInputUploadImage)[0].files[0])
		$(uploadImageDivLast).after uploadImageHtml
		setEventToLastInput()
		return
	if $(lastInputUploadImage).val().length == 0 && $(uploadImageDiv).size() != 1
		$(uploadImageDivLast).remove()
	return

setEventToLastInput = () ->
	$(lastInputUploadImage).change job
	return

$(document).ready (e) ->
	image_uploader.init()
	return

window.requestSignOut = new XMLHttpRequest()
window.requestSignOut.open("DELETE", "http://localhost:3000/users/sign_out", false)
