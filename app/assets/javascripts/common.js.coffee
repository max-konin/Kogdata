uploadImageDiv = "div.uploadImage"
uploadImageDivLast = uploadImageDiv + ":last"
lastInputUploadImage = uploadImageDivLast + " input"

setEventToLastInput = () ->
	innerHtml = $(uploadImageDivLast).html()
	job = (e) ->
		if $(lastInputUploadImage).val().length != 0
			$(uploadImageDivLast).after "<div class='uploadImage'>" + innerHtml + "</div>"
			setEventToLastInput()
		if $(lastInputUploadImage).val().length == 0 && $(uploadImageDiv).size() != 1
			$(uploadImageDivLast).remove()
		return
	job()
	$(lastInputUploadImage).change job
	return

$(document).ready (e) ->
	setEventToLastInput()
	return

window.requestSignOut = new XMLHttpRequest()
window.requestSignOut.open("DELETE", "http://localhost:3000/users/sign_out", false)
