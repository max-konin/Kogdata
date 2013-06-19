#= require dateFormat
#= require fullcalendar

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
error_message = {todo: "global"}
#if variable role is defined and it's value is contractor
if typeof role != 'undefined' and role == 'contractor'
	#so the contractor is watching all the bookings
	#and cant change the events
	enable_edit = false

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
			error_message_selector.show
			res = false
		return res
onDayClick = (date, allDay, jsEvent, view) ->
	$(this).attr('rel','popover')
	$(event_modal_selector).popover(container: this)
	$(this).css('background-color','green')
	$(event_modal_selector).popover 'show'
	$(this).addClass('selected-day')
	event_start = document.getElementById 'date-input'
	event_start.value = date
	error_message = document.getElementById 'error-div'
	return

add_event_on_submit = ()->
	date = event_start.value
	date1 = new Date event_start.value
	if add_event(date1, true)
		$(event_modal_selector).popover 'hide'

	else
		error_message.style.display = 'block'
	return
hide_event_modal = ()->
	$('.selected-day').removeClass 'selected-day'
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
}

update_calendar = () ->
	return unless $(calendar_selector).length != 0
	$(calendar_selector).fullCalendar 'removeEvents'
	request = {
		curDate: $(calendar_selector).fullCalendar('getDate').format 'isoDateTime'
	}
	event_title = document.getElementById 'title-input'
	event_description = document.getElementById 'description-input'
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


$(document).ready () ->
	$(bookings_selector).click bookings_on_click
	add_event_handler.call $(add_event_selectors.parent).find add_event_selectors.child
	$(calendar_selector).fullCalendar fullCalendarOption
	$(create_event_selector).click add_event_on_submit
	$(event_modal_selector).on 'hidden', hide_event_modal
	$('.fc-button-next, .fc-button-prev').click () ->
		update_calendar()
		return

	update_calendar()
	return
