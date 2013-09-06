#= require Calendar/controller
class clientController extends calendarHomeController

	change_calendar_date: (year, month, date) ->
		$(@calendar_selector).fullCalendar('gotoDate', year, month-1, date )
		@set_view('on_change_date')
		@set_current_date(year, month, date)
		@add_events()
		return

	set_current_date: (year, month, date) ->
		$('.fc-current-day').removeClass('fc-current-day')
		$('.fc-date'+date).addClass('fc-current-day')
		return

	current_date_on_change: () ->
		daysInMonth =  new Date($('#event_year').val(),$('#event_month').val(),0).getDate()
		$('#event_day').attr('max', daysInMonth)
		if $.isNumeric($('#event_day').val())
			$('#event_day').removeClass('invalid')
			if $('#event_day').val() > daysInMonth
				$('#event_day').val(daysInMonth)
			if $('#event_day').val() < 1
				$('#event_day').val(1)
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
			Calendar.set_current_date(date.getFullYear(), date.getMonth(), date.getDate())
		return

	on_change_month: () ->
		calendar_date = $(Calendar.calendar_selector).fullCalendar('getDate')
		daysInMonth =  new Date(calendar_date.getFullYear(), calendar_date.getMonth()+1 ,0).getDate()
		newDate = $('#event_day').val()
		if newDate > daysInMonth
			newDate = daysInMonth
		calendar_date.setDate(newDate)
		$(@calendar_selector).fullCalendar 'gotDate', calendar_date.getFullYear(), calendar_date.getMonth(), calendar_date.getDate()
		@set_current_date calendar_date.getFullYear(), calendar_date.getMonth(), calendar_date.getDate()
		$('#event_month').val calendar_date.getMonth()+1
		$('#event_year').val  calendar_date.getFullYear()
		$('#event_day').val calendar_date.getDate()
		return

	update_calendar: (flag) ->
		super(flag)
		if flag == 'on_change_date'
			@on_change_month()
		# load events
		@add_events()

	add_events: () ->
		$.ajax(
			type: 'get'
			url: "/users/#{user_id}/events.json"
			dataType: 'json'
			data: {
				curDate: $(@calendar_selector).fullCalendar('getDate').format 'isoDateTime'
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

	validate_event_data: () ->
		if $('form#new_event').find('.invalid').length
			return false
		if $('#event_description').val() == '' || $('#event_price').val() == ''
			return false
		return true

	on_add_form_submit: () ->
		if Calendar.validate_event_data()
			$('.invalid_message').hide()
			start = new Date $('#event_year').val(), $('#event_month').val()-1, $('#event_day').val(), $('#event_hour').val(), $('#event_minute').val()
			end = new Date $('#event_year').val()+1, $('#event_month').val()-1, $('#event_day').val()
			request = {
				 start: start.format 'isoDateTime'
				 end: end
				 location: $('#event_location').val()
				 type: $('#event_type').val()
				 description: $('#event_description').val()
				 price: $('#event_price').val()
			}
			$.ajax(
				type: 'post'
				url: "/users/#{user_id}/events"
				dataType: 'json'
				data: {
					events: request
					curDate: $(Calendar.calendar_selector).fullCalendar('getDate').format 'isoDateTime'
				}
				success: () ->
					day_selector = '.fc-date'+$('#event_day').val()
					$(day_selector).addClass('event-day')
				error: () ->
					console.log 'Error!!'
			)
		else
			$('.invalid_message').show()
		return false

	calendar_init: () ->
		@fullCalendarOption.dayClick = @on_day_click
		@add_event_handler.call $(@add_event_selectors.parent).find @add_event_selectors.child
		$(@calendar_selector).fullCalendar @fullCalendarOption
		$('form#new_event').submit(Calendar.on_add_form_submit)
		super
		return
window.Calendar = new clientController
window.Popover = new popoverController