class window.calendarShowController extends calendarHomeController
	otherEventColor: '#4C85BC'
	update_calendar: () ->
		return unless $(@calendar_selector).length != 0
		$(@calendar_selector).fullCalendar 'removeEvents'
		request = {
			curDate: $(@calendar_selector).fullCalendar('getDate').format 'isoDateTime'
		}
		$.ajax {
			type: 'GET'
			url: "office/all.json"
			dataType: 'json'
			data: request
			success: (response) ->
				events = JSON.parse response.div_contents.body
				for event in events
					if event.user_id == parseInt user_id
						event.color = calendarShowController::myEventColor
					else
						event.editable = false
						event.color = calendarShowController::otherEventColor
					$(calendarHomeController::calendar_selector).fullCalendar 'renderEvent', event, true
				return
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				return
		}
		return
window.Calendar = new calendarShowController