uploadImageDiv = "div.uploadImage"
uploadImageDivLast = uploadImageDiv + ":last"
lastInputUploadImage = uploadImageDivLast + " input"

setEventToLastInput = () ->
	innerHtml = $(uploadImageDivLast).html()
	$(lastInputUploadImage).change (e) ->
		if $(this).val().length != 0
			$(uploadImageDivLast).after "<div class='uploadImage'>" + innerHtml + "</div>"
			setEventToLastInput()
		if $(this).val().length == 0 && $(uploadImageDiv).size() != 1
			$(uploadImageDivLast).remove()
		return
	return

$(document).ready (e) ->
	setEventToLastInput()
	return
