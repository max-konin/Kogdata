$(document).ready () ->
	if $("select#user_role").val() == 'contractor'
		$("#price-div").show()
	$("select#user_role").on('change', () ->
		if $("select#user_role").val() == 'contractor'
			$("#price-div").show('slow')
		else
			$("#price-div").hide('slow')
			$("#user_price").val(null)
		return )

	validate_form("#new_user")
	return