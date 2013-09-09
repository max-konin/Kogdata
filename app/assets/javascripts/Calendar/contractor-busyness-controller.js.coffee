#= require Calendar/controller
class window.contractorBusynessController extends calendarHomeController

	calendar_inited: false
	busy_days: []
	update_calendar: () ->
		super
		calendarHomeController::busy_days = []
		user_id_for_show = parseInt document.location.href.substring(document.location.href.lastIndexOf('/') + 1);
		$('.busy-day').removeClass('busy-day')
		$.ajax {
			type: 'get'
			url: "/users/#{user_id_for_show}/busynesses"
			dataType: 'json'
			contentType: 'application/json'
			data: {
				curr_date: $(@calendar_selector).fullCalendar('getDate').format 'isoDateTime'
				random: String Math.random()
			}
			success: (response, status, jqXHR) ->
				busynesses = JSON.parse response.div_contents.body
				for busyness in busynesses
					date = new Date busyness.date
					day = date.getDate()
					calendarHomeController::busy_days[day] = busyness.id
					day_class = '.fc-date'+day
					$(day_class).addClass('busy-day')
				return
		}
	onDayClick: (date, allDay, jsEvent, view) ->
		month = date.getMonth()
		day_selector = this
		if month == $(calendarHomeController::calendar_selector).fullCalendar('getDate').getMonth()
			day = date.getDate()
			if !calendarHomeController::busy_days[day]
				request = {
					date: date.format 'isoDateTime'
					curr_date: $(calendarHomeController::calendar_selector).fullCalendar('getDate').format 'isoDateTime'
				}
				$.ajax {
					type: 'post'
					url: "/users/#{user_id}/busynesses.json"
					format: 'json'
					data: request
					success: (response) ->
						$(day_selector).children('div').addClass('busy-day')
						data = JSON.parse response.div_contents.body
						calendarHomeController::busy_days[day] = data.id
						return
				}
			else
				$.ajax {
					type: 'delete'
					url: "/users/#{user_id}/busynesses/#{calendarHomeController::busy_days[day]}.json"
					format: 'json'
					data: {curr_date: $(calendarHomeController::calendar_selector).fullCalendar('getDate').format 'isoDateTime'}
					success: () ->
						$(day_selector).children('div').removeClass('busy-day')
						delete calendarHomeController::busy_days[day]
						return
					error: () ->
						delete calendarHomeController::busy_days[day]
				}
		return
	calendar_init: () ->
		if !@calendar_inited
			console.log $(Calendar.calendar_selector).fullCalendar
			@fullCalendarOption.dayClick = @onDayClick
			Calendar.add_event_handler.call $(Calendar.add_event_selectors.parent).find Calendar.add_event_selectors.child
			$(Calendar.calendar_selector).fullCalendar Calendar.fullCalendarOption
		super
		return

window.Calendar = new contractorBusynessController
window.Popover = new popoverController