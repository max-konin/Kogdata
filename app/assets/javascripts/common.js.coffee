#=require 'live_search'

$(document).ajaxSend (e, r, s) ->
	if typeof AUTH_TOKEN == undefined
		return
	s.data = s.data || ""
	s.data += (if s.data then "&" else "") + "authenticity_token=" + encodeURIComponent AUTH_TOKEN
	return

$(document).ready () ->
	live_search = new searcher "/users/search", "#searchPattern", ".search_content"
