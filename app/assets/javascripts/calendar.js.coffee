#= require dateFormat
#= require fullcalendar

$(document).ready ->
	enableEdit = true
	InputTitle = { todo: "global"}
	InputText = { todo: "global" }
	#if variable role is defined
	if (typeof(role) != 'undefined')
		#and it's value is contractor
		if (role == 'contractor')
			#so the contractor is watching all the bookings
			#and cant change the events
			enableEdit = false

	$('#show-bookings').click (event) ->
		event.preventDefault()
		$.ajax {
			url:'/office/all',
			dataType:'json',
			success: (response) ->
				events = JSON.parse response.div_contents.body
				for event in events
					$('#calendar').fullCalendar('renderEvent', event, true)
				return
			}
		return

	$('#external-events div.external-event').each () ->
		# create an Event Object (http:#arshaw.com/fullcalendar/docs/event_data/Event_Object/)
		eventObject = $(this).data() # use the element's text as the event title
		#make a copy of Event Object
		copiedEventObject = $.extend {}, eventObject
		# store the Event Object in the DOM element so we can get to it later
		$(this).data 'eventObject', eventObject
		# make the event draggable using jQuery UI
		$(this).draggable {
			zIndex: 999
			revert: true			# will cause the event to go back to its
			revertDuration: 0		#  original position after the drag
		}
		return

	$('#calendar').fullCalendar {
		header: {
			left: 'prev',
			right: 'next',
			center: 'title',
			prev: 'circle-triangle-w',
			next: 'circle-triangle-e'
		}
		firstDay: 1
		timeFormat: "%FT%T.%LZ"
		editable: enableEdit
		droppable: true
		eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
			EventObject = event
			Start4request = EventObject.start.format('isoDateTime')
			request = {
				title: EventObject.title
				start:Start4request
				description: EventObject.description
			}
			# current date of the calendar
			currentDate = $('#calendar').fullCalendar('getDate')
			currentDate = currentDate.format('isoDateTime')
			$.ajax {
				url:"/events/update.json"
				dataType: 'json'
				contentType: 'application/json; charset-utf8'
				data: {
					events: request
					id: EventObject.id
					curDate:currentDate
				}
				success: () ->
					return
				error: (XMLHttpRequest, textStatus, errorThrown) ->
					console.log("Error: " + errorThrown)
					revertFunc()
					return
			}
			return
		# this allows things to be dropped onto the calendar !!!
		drop: (date, allDay) -> # this function is called when something is dropped
			if InputTitle.value != '' and InputText.value != ''
				# retrieve the dropped element's stored Event Object
				originalEventObject = $(this).data 'eventObject'
				# we need to copy it, so that multiple events don't have a reference to the same object
				copiedEventObject = $.extend {}, originalEventObject
				# assign it the date that was reported
				copiedEventObject = {
					allDay: allDay
					title: InputTitle.value
					description: InputText.value
					start: date
				}
				Start4request = date.format 'isoDateTime'
				# current date of calendar
				currentDate = $('#calendar').fullCalendar('getDate').format 'isoDateTime'
				request = {
					title: copiedEventObject.title
					start: Start4request
					description: copiedEventObject.description
				}
				#request = JSON.stringify(request);
				$.ajax {
					url: "/events/new.json"
					contentType: 'application/json; charset-utf8'
					dataType: 'json'
					data: {
						events: request
						curDate: currentDate
					}
					success: (response) ->
						events = JSON.parse response.div_contents.body
						copiedEventObject.id = events.id
						$('#calendar').fullCalendar 'renderEvent', copiedEventObject, true
						# is the "remove after drop" checkbox checked?
						if $('#drop-remove').is ':checked'
							# if so, remove the element from the "Draggable Events" list
							$(this).remove()
						return
					error: (XMLHttpRequest, textStatus, errorThrown) ->
						alert("Error: " + errorThrown)
						return
				}
			return
	}

	updateCalendar = () ->
		currentDate = $('#calendar').fullCalendar('getDate').format 'isoDateTime'
		request = {
			curDate: currentDate
		}
		InputTitle = document.getElementById 'EventTitle'
		InputText = document.getElementById 'EventDescription'
		$.ajax {
			url: "/events/all.json"
			dataType: 'json'
			contentType: 'application/json; charset-utf8'
			data: request
			success: (response) ->
				events = JSON.parse response.div_contents.body
				for event in events
					$('#calendar').fullCalendar 'renderEvent', event, true
				return
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				return
		}

	$('.fc-button-next').click () ->
		$('#calendar').fullCalendar 'removeEvents'
		updateCalendar()

	$('.fc-button-prev').click () ->
		$('#calendar').fullCalendar 'removeEvents'
		updateCalendar()

	#updateCalendar()
