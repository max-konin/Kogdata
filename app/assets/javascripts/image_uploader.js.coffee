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
