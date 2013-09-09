#= require 'Calendar/Controllers/contractor-busyness-controller'
class contractorBusynessControllerShow extends  contractorBusynessController
	onDayClick: () ->
		console.log 'somthing is gonna happend'
		return

	calendar_init: () ->
		@fullCalendarOption.dayClick = @onDayClick
		Calendar.add_event_handler.call $(Calendar.add_event_selectors.parent).find Calendar.add_event_selectors.child
		$(Calendar.calendar_selector).fullCalendar Calendar.fullCalendarOption
		@calendar_inited = true
		super
		return
window.Calendar = new contractorBusynessControllerShow