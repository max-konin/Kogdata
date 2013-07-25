current_date_on_change = () ->
	daysInMonth =  new Date($('#event_year').val(),$('#event_month').val(),0).getDate()
	$('#event_day').attr('max', daysInMonth)
	if $.isNumeric($('#event_day').val()) && $('#event_day').val() <= daysInMonth && $('#event_day').val() >= 1
		$('#event_day').removeClass('invalid')
	else
		$('#event_day').addClass('invalid')
	return

current_time_on_change = ()	->
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

addZero = () ->
	if $(this).val() == ''
		$(this).removeClass('invalid')
		$(this).val('00')
	if !$(this).hasClass('invalid')
		if $(this).val().length == 1
			$(this).val('0'+$(this).val())
	return

price_on_change = () ->
	if $.isNumeric($(this).val())
		$(this).removeClass('invalid')
	else
		$(this).addClass('invalid')
	return

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
	if $('#calendar').length
		$('.fc-button-prev').html('<label> < </label>')
		$('.fc-button-next').html('<label> > </label>')

		
		for header in $('.fc-widget-header')
			header.innerHTML = '<div class = "fc-header-inside"> '+ header.innerHTML+'</div>'
		currentDate = new Date()
		month = currentDate.getMonth()
		day = currentDate.getDate()
		year = currentDate.getYear()
		opt = $("option[value="+month+"]")

		html = $("<div>").append(opt.clone()).html()
		html = html.replace(/\>/, ' selected="selected">')
		opt.replaceWith(html)
		$('#event_day').val(day)
		$('#event_day').on('input', current_date_on_change)
		$('#event_month').on('change', current_date_on_change)
		$('#event_hour').on('input', current_time_on_change)
		$('#event_minute').on('input', current_time_on_change)
		$('#event_hour').on('change', addZero)
		$('#event_minute').on('change', addZero)
		$('#event_price').on('input', price_on_change)
	return