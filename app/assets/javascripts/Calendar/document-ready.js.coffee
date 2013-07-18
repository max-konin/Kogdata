$(document).ready () ->
	$('body').on('mousedown', (e) ->
		if  $(e.target).parents('.popover').size() == 0
			Popover.hide()
	)

	Popover.get_inside_popover_new()
	#	$(bookings_selector).click Calendar.bookings_on_click
	Calendar.add_event_handler.call $(Calendar.add_event_selectors.parent).find Calendar.add_event_selectors.child
	$(Calendar.calendar_selector).fullCalendar Calendar.fullCalendarOption
	$('body').on('click', '.close-event', Popover.close_event)
	$('body').on('click', '.reopen-event', Popover.reopen_event)
	$('.fc-button-next, .fc-button-prev').click () ->
		Calendar.update_calendar()
		return

	$('body').on('click', '.popover submit', () ->
		Calendar.add_event_on_submit()
		return)
	Calendar.update_calendar()
	$('.fc-button-prev').html('<label> < </label>')
	$('.fc-button-next').html('<label> > </label>')

	$('.fc-widget-header').html('<div class = "fc-header-inside"> '+ $('.fc-widget-header').html().toString()+'</div>')
	return