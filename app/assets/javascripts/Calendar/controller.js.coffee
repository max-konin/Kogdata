#= require Calendar/init

class window.calendarHomeController
	myEventColor: '#2D46AD'
	calendar_selector: '#calendar'
	create_event_selector: '#create-event-button'
	add_event_selectors: {
		parent: '#external-events'
		child: 'div.external-event'
	}
	add_event: (date, allDay) -> # this function is called when something is dropped
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
			console.log request
			$.ajax {
				type: 'POST'
				url: "/users/#{user_id}/events.json"
				dataType: 'json'
				data: {
					events: request
					curDate: $(@calendar_selector).fullCalendar('getDate').format 'isoDateTime'
				}
				success: (response) ->
					events = JSON.parse response.div_contents.body
					clone_event.id = events.id
					clone_event.user_id = events.user_id
					clone_event.color = calendarHomeController::myEventColor
					$(calendarHomeController::calendar_selector).fullCalendar 'renderEvent', clone_event, true
					return
				error: (XMLHttpRequest, textStatus, errorThrown) ->
					console.log "Error: " + errorThrown
					return
			}
		else
			res = false
		return res

	add_event_on_submit: ()->
		window.event_title = document.getElementsByClassName('title-input')[0]
		window.event_description = document.getElementsByClassName('description-input')[0]
		date1 = new Date document.getElementById('date-input').value
		calendarHomeController::add_event(date1, true)
		return

	update_event: (event, day_delta, minute_delta, all_day, revert_func) ->
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
				curDate: $(calendarHomeController::calendar_selector).fullCalendar('getDate').format 'isoDateTime'
			}
			success: () ->
				return
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				console.log "Error: " + errorThrown
				revert_func()
				return
		}
		return

	update_calendar: () ->
		return unless $(@calendar_selector).length != 0
		$(@calendar_selector).fullCalendar 'removeEvents'
		request = {
			curDate: $(@calendar_selector).fullCalendar('getDate').format 'isoDateTime'
		}
		$.ajax {
			type: 'GET'
			url: "users/#{user_id}/events.json"
			dataType: 'json'
			data: request
			success: (response) ->
				events = JSON.parse response.div_contents.body
				for event in events
					event.color = calendarHomeController::myEventColor
					$(calendarHomeController::calendar_selector).fullCalendar 'renderEvent', event, true
				return
			error: (XMLHttpRequest, textStatus, errorThrown) ->
				return
		}
		return
	onDragStart: () ->
		$('.clicked').removeClass('clicked')
		return

	onDayClick: (date, allDay, jsEvent, view) ->
		window.Popover.hide()
		window.Popover.show($(this),date,'day','','')
		return

	onEventClick: (event, jsEvent, view) ->
		Popover.hide()
		Popover.show($(this),'','event', event.id,event)
		return
	add_event_handler: () ->
		this.draggable {
			zIndex: 10
			revert: true			# will cause the event to go back to its
			revertDuration: 0		# original position after the drag
		}
		return
	fullCalendarOption: {
		header: {
			left: 'prev'
			right: 'next'
			center: 'title'
			prev: 'circle-triangle-w'
			next: 'circle-triangle-e'
		}
		firstDay: 1
		height: 600
		monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь']
		monthNamesShort: ['Янв.','Фев.','Март','Апр.','Май','Июнь','Июль','Авг.','Сент.','Окт.','Ноя.','Дек.']
		dayNames: ["Воскресенье","Понедельник","Вторник","Среда","Четверг","Пятница","Суббота"]
		dayNamesShort: ["ВС","ПН","ВТ","СР","ЧТ","ПТ","СБ"]
		timeFormat: "%FT%T.%LZ"
		editable: true
		droppable: true
		eventDrop: @::update_event
	# this allows things to be dropped onto the calendar !!!
		drop: @::add_event
		dayClick: @::onDayClick
		eventClick: @::onEventClick
		eventDragStart: @::onDragStart
	}

class window.popoverController
	popover_id: "null"
	show: (owner, date, type, number,event) ->
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
				windowWidth = $(window).width()
				thisLeft =  $('#'+this.popover_id).offset().left + $('#'+this.popover_id).width()
				if  windowWidth - thisLeft < 250
					@init_popover_new_options.placement = 'left'
				else
					@init_popover_new_options.placement = 'right'
				$('#'+this.popover_id).popover(@init_popover_new_options).popover 'show'
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
					success: (data) ->
						inside_popover_show = data
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
				windowWidth = $(window).width()
				thisLeft =  $('#'+this.popover_id).offset().left + $('#'+this.popover_id).width()
				if  windowWidth - thisLeft < 250
					init_popover_show_options.placement = 'left'
				$('#'+this.popover_id).popover(init_popover_show_options).popover 'show'
				$('.title-label').html event.title
				$('.description-label').html event.description
			else
				owner.removeClass 'clicked'
		return
	hide: () ->
		$('.selected-day').removeClass 'selected-day'
		$('#'+this.popover_id).popover 'destroy'
		return

	get_inside_popover_new: () ->
		$.ajax {
			type: 'GET'
			url: 'calendar/new_form'
			dataType: 'html'
			success: (data) ->
				window.inside_popover_new = data
				return
		}
		return

	init_popover_new_options: {
		html: true
		content: () ->
			return inside_popover_new
		container: 'body'
		trigger: 'manual'
	}
window.Calendar = new calendarHomeController

