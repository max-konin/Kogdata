#= require Calendar/Controllers/client-controller
class clientControllerShow extends clientController
	on_day_click: (date) ->
		if $(this).hasClass('fc-other-month')
			return false
		real_day = $(this).children('.real-day')
		if $(real_day).hasClass('fc-show-events')
			$(real_day).removeClass('fc-show-events')
			client.events()
		else
			$('.fc-show-events').removeClass('fc-show-events')
			$(real_day).addClass('fc-show-events')
			data = {
				show_date: date.format 'isoDateTime'
			}
			client.events {data: data}
		return

	calendar_init: () ->
		@fullCalendarOption.dayClick = @on_day_click
		@add_event_handler.call $(@add_event_selectors.parent).find @add_event_selectors.child
		$(@calendar_selector).fullCalendar @fullCalendarOption
		@calendar_inited
		@calendar_inited = true
		super
		$('.fc-current-day').removeClass('fc-current-day')
		return
window.Calendar = new clientControllerShow