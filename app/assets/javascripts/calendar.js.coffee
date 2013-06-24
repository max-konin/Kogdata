#= require dateFormat
#= require fullcalendar
#= require bootstrap-tooltip
#= require bootstrap-popover

calendar_selector = '#calendar'
bookings_selector = '#show-bookings'
event_modal_selector = '#events-modal'
create_event_selector = '#create-event-button'
error_message_selector = '#error-div'
add_event_selectors = {
	parent: '#external-events'
	child: 'div.external-event'
}

role = $.cookie 'role'
user_id = $.cookie 'user_id'
enable_edit = true
event_title = { todo: "global" }
event_description = { todo: "global" }
event_start = {todo: "global"}
inside_popover_new = {todo: "global"}
inside_popover_show = {todo: "global"}



# Get all events on calendar(bind by click on something)
bookings_on_click = (event) ->
	event.preventDefault()
	$.getJSON '/office/all.json', (response) ->
			events = JSON.parse response.div_contents.body
			$(calendar_selector).fullCalendar 'removeEvents'
			for event in events
				$(calendar_selector).fullCalendar 'renderEvent', event, true
			return
	return

# Bind to draggable something, that then will be droppable on calendar(call a bit tricky, see below)
add_event_handler = () ->
	this.draggable {
		zIndex: 10
		revert: true			# will cause the event to go back to its
		revertDuration: 0		# original position after the drag
	}
	return

update_event = (event, day_delta, minute_delta, all_day, revert_func) ->
		request = {
			title: event.title
			start: event.start.format 'isoDateTime'
			description: event.description
		}
		$.ajax {
			type: 'PUT'
			url: "/users/#{user_id}/events/#{event.id}.json"
			dataType: 'json'
			data: {
				events: request
				curDate: $(calendar_selector).fullCalendar('getDate').format 'isoDateTime'
			}
			success: () ->
				return
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				console.log "Error: " + errorThrown
				revert_func()
				return
		}
		return

add_event = (date, allDay) -> # this function is called when something is dropped
		res = true
		if event_title.value != '' and event_description.value != ''
			clone_event = {
				allDay: allDay
				title: event_title.value
				description: event_description.value
				start: date
			}
			request = {
				title: clone_event.title
				start: date.format 'isoDateTime'
				description: clone_event.description
			}
			$.ajax {
				type: 'POST'
				url: "/users/#{user_id}/events.json"
				dataType: 'json'
				data: {
					events: request
					curDate: $(calendar_selector).fullCalendar('getDate').format 'isoDateTime'
				}
				success: (response) ->
					events = JSON.parse response.div_contents.body
					clone_event.id = events.id
					$(calendar_selector).fullCalendar 'renderEvent', clone_event, true
					return
				error: (XMLHttpRequest, textStatus, errorThrown) ->
					console.log "Error: " + errorThrown
					return
			}
		else
			res = false
		return res

add_event_on_submit = ()->
	event_title = document.getElementsByClassName('title-input')[0]
	event_description = document.getElementsByClassName('description-input')[0]
	date1 = new Date event_start.value
	add_event(date1, true)
	return

init_popover_new_options = {
	html: true
	content: () ->
		return inside_popover_new
	container: 'body'
	trigger: 'manual'
}


init_popover_show_options = {
	html: true
	content: () ->
		return inside_popover_show
	container: 'body'
	trigger: 'manual'
}
#on day clik method!!!1
onDayClick = (date, allDay, jsEvent, view) ->
	if !$(this).hasClass('selected-day')
		parent = $(this).parent()
		placement = 'top'
		if parent.hasClass('fc-week0')
    placement = 'bottom'
  console.log placement
		init_popover_new_options['placement'] = placement
		$('.selected-day').popover 'destroy'
		$('.selected-event').popover 'destroy'
		$('.selected-day').removeClass 'selected-day'
		$(this).addClass('selected-day')
		$('.selected-day').popover(init_popover_new_options).popover 'show'
		event_start = document.getElementById 'date-input'
		event_start.value = date
	else
		$('.selected-day').popover 'destroy'
		$('.selected-day').removeClass 'selected-day'
	return


onEventClick = (event, jsEvent, view) ->
	if !$(this).hasClass('selected-event')
		$('.selected-event').popover 'destroy'
		$('.selected-day').popover 'destroy'
		$('.title-label').removeClass 'title-label'
		p = $(this).position()
		top =  p.top
		placement = 'top'
		if top < 154.0
			placement = 'bottom'
		init_popover_show_options['placement'] = placement
		$('.selected-day').removeClass 'selected-day'
		$('.selected-event').removeClass 'selected-event'
		$(this).addClass('selected-event')
		document.getElementById('title-for-show').value = event.title
		document.getElementById('description-for-show').value = event.description
		$('.selected-event').popover(init_popover_show_options).popover 'show'
	else
		$('.selected-event').popover 'destroy'
		$('.selected-event').removeClass 'selected-event'
	return


fullCalendarOption = {
	header: {
		left: 'prev'
		right: 'next'
		center: 'title'
		prev: 'circle-triangle-w'
		next: 'circle-triangle-e'
	}
	firstDay: 1
	timeFormat: "%FT%T.%LZ"
	editable: enable_edit
	droppable: true
	eventDrop: update_event
	# this allows things to be dropped onto the calendar !!!
	drop: add_event
	dayClick: onDayClick
	eventClick: onEventClick
}

update_calendar = () ->
	return unless $(calendar_selector).length != 0
	$(calendar_selector).fullCalendar 'removeEvents'
	request = {
		curDate: $(calendar_selector).fullCalendar('getDate').format 'isoDateTime'
	}
	$.ajax {
		type: 'GET'
		url: "/users/#{user_id}/events.json"
		dataType: 'json'
		data: request
		success: (response) ->
			events = JSON.parse response.div_contents.body
			for event in events
				$(calendar_selector).fullCalendar 'renderEvent', event, true
			return
		error: (XMLHttpRequest, textStatus, errorThrown) ->
			return
	}
	return

get_inside_popover = () ->
	$.ajax {
		type: 'GET'
		url: 'calendar/new_form'
		dataType: 'html'
		success: (data) ->
			inside_popover_new = data
			return
	}
	$.ajax {
		type: 'GET'
		url: 'calendar/show_form'
		dataType: 'html'
		success: (data) ->
			inside_popover_show = data
			console.log data
			return
	}
	return


$(document).ready () ->
	get_inside_popover()
	$(bookings_selector).click bookings_on_click
	add_event_handler.call $(add_event_selectors.parent).find add_event_selectors.child
	$(calendar_selector).fullCalendar fullCalendarOption
	console.log $(create_event_selector).click
	$('.fc-button-next, .fc-button-prev').click () ->
		$('.selected-day').popover 'destroy'
		#$('.selected-event').popover ''
		$('.selected-event').removeClass 'selected-event'
		$('.selected-day').removeClass 'selected-day'
		update_calendar()
		return
	$('body').on('shown', '.selected-event',()->
		console.log document.getElementById('title-for-show').value
		console.log document.getElementsByClassName('title-label')
		document.getElementsByClassName('title-label')[0].innerHTML = document.getElementById('title-for-show').value
		return
	)
	$('body').on('click', '.popover submit', () ->
		add_event_on_submit()
		return)
	update_calendar()
	return
