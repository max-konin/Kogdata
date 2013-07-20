
$(document).ready () ->
	if $("select#user_role").val() == 'contractor'
		$("#price-div").show()
	$("select#user_role").on('change', () ->
		if $("select#user_role").val() == 'contractor'
			$("#price-div").show('slow')
		else
			$("#price-div").hide('slow')
			$("#price-field").val(null)
		return )
	return