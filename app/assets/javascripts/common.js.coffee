$(document).ajaxSend (e, r, s) ->
	if typeof AUTH_TOKEN == undefined
		return
	s.data = s.data || ""
	s.data += (s.data ? "&" : "") + "authenticity_token=" + encodeURIComponent AUTH_TOKEN
	#s.data['authenticity_token']  = encodeURIComponent AUTH_TOKEN
	return
