#= require Calendar/controller
class clientController extends calendarHomeController

	change_calendar_date: (year, month, date) ->
		$(@calendar_selector).fullCalendar('gotoDate', year, month-1, date )
		@set_view('on_change_date')
		@set_current_date(year, month, date)
		return

	set_current_date: (year, month, date) ->
		$('.fc-current-day').removeClass('fc-current-day')
		$('.fc-date'+date).addClass('fc-current-day')
		return


	current_date_on_change: () ->
		daysInMonth =  new Date($('#event_year').val(),$('#event_month').val(),0).getDate()
		$('#event_day').attr('max', daysInMonth)
		if $.isNumeric($('#event_day').val()) && $('#event_day').val() <= daysInMonth && $('#event_day').val() >= 1
			$('#event_day').removeClass('invalid')
			Calendar.change_calendar_date($('#event_year').val(), $('#event_month').val(), $('#event_day').val())
		else
			$('#event_day').addClass('invalid')
		return

	current_time_on_change:  ()	->
		if $.isNumeric($(this).val())
			if $(this).is('#event_hour')
				if $(this).val() >= 0 &&  $(this).val() <= 24
					$(this).removeClass('invalid')
				else
					$(this).addClass('invalid')
			if $(this).is('#event_minute')
				if $(this).val() >= 0 &&  $(this).val() <= 59
					$(this).removeClass('invalid')
				else
					$(this).addClass('invalid')
		else
			$(this).addClass('invalid')
		return

	add_zero: () ->
		if $(this).val() == ''
			$(this).removeClass('invalid')
			$(this).val('00')
		if !$(this).hasClass('invalid')
			if $(this).val().length == 1
				$(this).val('0'+$(this).val())
		return

	price_on_change:  () ->
		if $.isNumeric($(this).val())
			$(this).removeClass('invalid')
		else
			$(this).addClass('invalid')
		return


	set_view: (flag) ->
		super

		if flag != 'on_change_date'
			$('.fc-today').children('.real-day').addClass('fc-current-day')
			currentDate = new Date()
			month = currentDate.getMonth()
			day = currentDate.getDate()
			opt = $("option[value="+(month+1)+"]")
			html = $("<div></div>").append(opt.clone()).html()
			html = html.replace(/\>/, ' selected="selected">')
			opt.replaceWith(html)
			$('#event_day').val(day)
			$('#event_day').on('input', @current_date_on_change)
			$('#event_month').on('change', @current_date_on_change)
			$('#event_year').on('change', @current_date_on_change)
			$('#event_hour').on('input', @current_time_on_change)
			$('#event_minute').on('input', @current_time_on_change)
			$('#event_hour').on('change', @add_zero)
			$('#event_minute').on('change', @add_zero)
			$('#event_price').on('input', @price_on_change)
		return
	on_day_click: (date) ->
		month = date.getMonth()
		if month == $(calendarHomeController::calendar_selector).fullCalendar('getDate').getMonth()
			$('#event_day').val(date.getDate())
			Calendar.set_current_date(date.getYear(), date.getMonth(), date.getDate())
		return
	on_change_month: () ->
		calendar_date = $(Calendar.calendar_selector).fullCalendar('getDate')
		$('#event_month').val calendar_date.getMonth()
		calendar_date.setDate $('#event_day').val()
		Calendar.change_calendar_date calendar_date.getYear(), calendar_date.getMonth(), calendar_date.getDate()
		return

	calendar_init: () ->
		@fullCalendarOption.dayClick = @on_day_click
		Calendar.add_event_handler.call $(Calendar.add_event_selectors.parent).find Calendar.add_event_selectors.child
		$(Calendar.calendar_selector).fullCalendar Calendar.fullCalendarOption
		$('.fc-button-prev').click @on_change_month
		$('.fc-button-next').click @on_change_month
		super
		return
window.Calendar = new clientController
window.Popover = new popoverController