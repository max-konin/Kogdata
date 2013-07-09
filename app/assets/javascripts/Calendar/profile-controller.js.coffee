class window.calendarProfileController extends calendarHomeController
	profileUserId: null
	update_calendar: () ->
		return unless $(@calendar_selector).length != 0
		$(@calendar_selector).fullCalendar 'removeEvents'
		url = document.location.href
		rExp1 = /users[/][0-9]+/
		urlPart = url.match(rExp1)[0]
		rExp2 = /[0-9]+/
		calendarProfileController::profileUserId = parseInt urlPart.match(rExp2)
		if @profileUserId == parseInt user_id
			super()
		else
			request = {
				curDate: $(@calendar_selector).fullCalendar('getDate').format 'isoDateTime'
			}
			$.ajax {
				type: 'GET'
				url: "/users/#{@profileUserId}/events.json"
				dataType: 'json'
				data: request
				success: (response) ->
					events = JSON.parse response.div_contents.body
					for event in events
						event.editable = false
						event.color = calendarHomeController::otherEventColor
						$(calendarHomeController::calendar_selector).fullCalendar 'renderEvent', event, true
					return
				error: (XMLHttpRequest, textStatus, errorThrown) ->
					return
			}
		return
class window.popoverProfileController extends popoverController
	show: (owner, date, type, number,event) ->
		console.log 'Profile!!!'
		if type == 'event'
			super(owner, date, type, number,event)
		if type == 'day' && Calendar.profileUserId == parseInt user_id
			super(owner, date, type, number,event)
		return
window.Calendar = new calendarProfileController
window.Popover = new popoverProfileController