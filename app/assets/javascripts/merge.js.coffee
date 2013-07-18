

$(document).ready ->
	$(".radio-name").on("change", () ->
		if $('input:radio[name=radio-name]:checked').val() == 'other-name'
			$("#text-name").show('slow')
		else
			$("#text-name").hide('slow')
	)

	$(".radio-email").on("change", () ->
		if $('input:radio[name=radio-email]:checked').val() == 'other-email'
			$("#text-email").show('slow')
		else
			$("#text-email").hide('slow')
	)