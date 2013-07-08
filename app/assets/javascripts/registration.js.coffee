
$(document).ready () ->
	$("select#user_role").on('change', () ->
		if $("select#user_role").val() == 'contractor'
			$("#price-field").show('slow')
		else
			$("#price-field").hide('slow')
		return )
	return