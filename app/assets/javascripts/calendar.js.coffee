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
Popover = {todo: "global"}



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
	date1 = new Date document.getElementById('date-input').value
	add_event(date1, true)
	return

get_inside_popover_new = () ->
	$.ajax {
		type: 'GET'
		url: 'calendar/new_form'
		dataType: 'html'
		success: (data) ->
			inside_popover_new = data
			return
	}
	return
get_inside_popover_show = (event_id) ->


	return

init_popover_new_options = {
	html: true
	content: () ->
		return inside_popover_new
	container: 'body'
	trigger: 'manual'
}


#on day clik method!!!1
onDayClick = (date, allDay, jsEvent, view) ->
	Popover.hide()
	Popover.show($(this),date,'day','','')
	return


onEventClick = (event, jsEvent, view) ->
	Popover.hide()
	Popover.show($(this),'','event', event.id,event)
	return

onDragStart = () ->
	$('.clicked').removeClass('clicked')
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
	eventDragStart: onDragStart
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

popoverController = () ->
	this.popover_id = "null"
	this.show = (owner, date, type, number,event) ->
		inside_popover_show = 'null'
		if date != ''
			this.popover_id = 'day'+date.getDate().toString() + number + ""
		else
			this.popover_id = number + ""
		if type == 'day'
			if !owner.hasClass 'clicked'
				$('.clicked').removeClass('clicked')
				owner.addClass 'clicked'
				owner.addClass 'selected-day'
				owner.attr("id", this.popover_id)
#				console.log this.popover_id
				$('#'+this.popover_id).popover(init_popover_new_options).popover 'show'
				document.getElementById('date-input').value = date
			else
				owner.removeClass 'clicked'
		if type == 'event'
			if !owner.hasClass 'clicked'
				$('.clicked').removeClass('clicked')
				owner.addClass 'clicked'
				owner.addClass 'selected-event'
				owner.attr("id", this.popover_id)
#				console.log get_inside_popover_show(event.id)
				$.ajax {
					type: 'GET'
					url: "calendar/show_form/#{event.id}"
					async: false
					dataType: 'html'
					contentType: 'application/json'
					data: {event_id: event.id}
					success: (data) ->
						inside_popover_show = data
						console.log data
						return
					error: () ->
						console.log 'Error!!'
						return
				}
				init_popover_show_options = {
					html: true
					content: () ->
						return inside_popover_show
					container: 'body'
					trigger: 'manual'
				}
#				console.log init_popover_show_options.content(event.id)
#				console.log init_popover_new_options.content()
				#init_popover_show_options['content'] = init_popover_show_options['content'] +"<a href='users/"+user_id+"/events/"+event.id+"'> to photo"
				#console.log init_popover_show_options
				$('#'+this.popover_id).popover(init_popover_show_options).popover 'show'
				$('.title-label').html event.title
				$('.description-label').html event.description
			else
				owner.removeClass 'clicked'
		return
	this.hide = () ->
		$('.selected-day').removeClass 'selected-day'
		$('#'+this.popover_id).popover 'destroy'
		return
	return



$(document).ready () ->
	$('body').on('mousedown', (e) ->
		if  $(e.target).parents('.popover').size() == 0
			Popover.hide()
	)

	get_inside_popover_new()
	Popover = new popoverController()
	$(bookings_selector).click bookings_on_click
	add_event_handler.call $(add_event_selectors.parent).find add_event_selectors.child
	$(calendar_selector).fullCalendar fullCalendarOption
	$('.fc-button-next, .fc-button-prev').click () ->
		$('.selected-day').popover 'destroy'
		#$('.selected-event').popover ''
#		$('.selected-event').removeClass 'selected-event'
		$('.selected-day').removeClass 'selected-day'
		update_calendar()
		return

	$('body').on('shown', '.popover',()->
		#console.log document.getElementById('title-for-show').value
		#console.log document.getElementsByClassName('title-label')
		$(this).find('.title-label').html '!!!!'
		#document.getElementsByClassName('title-label')[0].innerHTML = document.getElementById('title-for-show').value
		return
	)

	$('body').on('click', '.popover submit', () ->
		add_event_on_submit()
		return)
	update_calendar()
	return
