class window.showAllEventsController extends calendarHomeController
	update_calendar: () ->
		super
		$.ajax(
			type: 'get'
			url: document.location.href + "/events.json"
			dataType: 'json'
			data: {
				curDate: $(@calendar_selector).fullCalendar('getDate').format 'isoDateTime'
				show_all: true
				random: String Math.random()
			}
			success: (response) ->
				events = JSON.parse response.div_contents.body
				if events.length
					for event in events
						date = new Date event.start
						day_selector = '.fc-date'+ date.getDate()
						$(day_selector).addClass('event-day')
				return
		)
		return
	on_day_click: (date) ->
		if $(this).children('.event-day').length
			data = {
				show_date: date.format 'isoDateTime'
				show_all: true
			}
			photograph.events {data: data}
		else
			photograph.destroy_events()
		return
	calendar_init: () ->
		@fullCalendarOption.dayClick = @on_day_click
		@add_event_handler.call $(@add_event_selectors.parent).find @add_event_selectors.child
		$(@calendar_selector).fullCalendar @fullCalendarOption
		super
		return
