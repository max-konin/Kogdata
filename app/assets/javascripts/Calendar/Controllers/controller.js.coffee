#= require Calendar/init

class window.calendarHomeController
	myEventColor: '#2D46AD'
	otherEventColor: '#4C85BC'
	closedEventColor: '#BABABA'
	calendar_selector: '#calendar'
	create_event_selector: '#create-event-button'
	add_event_selectors: {
		parent: '#external-events'
		child: 'div.external-event'
	}

	calendar_inited: false

	calendar_init: () ->
		#REMEMBER: if you want extend this class and add new events(methods)
		# you have override calendar_inint() method and add new events to the fullCalendarOption
		# property and init fullcalendar see example in contractor-busyness-controller

		$.ajax(
			type: 'get'
			url: '/users/user_id'
			dataType: 'json'
			async: false
			data: {
				random: String Math.random()
			}
			success: (response)->
				data = JSON.parse response.div_contents.body
				window.user_id = data.user_id
				return
		)

#		$('body').on('mousedown', (e) ->
#			if  $(e.target).parents('.popover').size() == 0
#				Popover.hide()
#		)
#		#	$(bookings_selector).click Calendar.bookings_on_click
#		$('body').on('click', '.close-event', Popover.close_event)
#		$('body').on('click', '.reopen-event', Popover.reopen_event)
		$('.fc-button-next, .fc-button-prev').click () ->
			Calendar.update_calendar('on_change_date')
			return

		$('body').on('click', '.popover submit', () ->
			Calendar.add_event_on_submit()
			return)
		Calendar.update_calendar()
		return

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


	set_view: () ->
		$('.fc-button-prev').html('<label> < </label>')
		$('.fc-button-next').html('<label> > </label>')

		for header in $('.fc-widget-header')
			header.innerHTML = '<div class = "fc-header-inside"> '+ header.innerHTML+'</div>'
		$('td.fc-widget-content').children('div').addClass('real-day')
		days = document.getElementsByClassName('real-day')
		for day in days
			for className in $(day).attr('class').split(' ')
				if className.match(/fc-date+/)
					$(day).removeClass(className)
			date = $(day).children('.fc-day-number').html()
			className = 'fc-date'+date
			if !$(day).parents('.fc-other-month').length
				$(day).addClass(className)
		return


	update_calendar: (flag) ->
		return unless $(@calendar_selector).length != 0
		@set_view(flag)
		return

	onDragStart: () ->
		$('.clicked').removeClass('clicked')
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
		eventClick: @::onEventClick
		eventDragStart: @::onDragStart
	}


class window.popoverController

	popover_id: "null"
	event: "null"
	inside_popver_show: "null"
	show: (owner, date, type, number,event) ->
		inside_popover_show = 'null'
		if date != ''
			popoverController::popover_id = 'day'+date.getDate().toString() + number + ""
		else
			popoverController::popover_id = number + ""
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
			popoverController::event = event
			if !owner.hasClass 'clicked'
				$('.clicked').removeClass('clicked')
				owner.addClass 'clicked'
				owner.addClass 'selected-event'
				owner.attr("id", this.popover_id)
				#				console.log get_inside_popover_show(event.id)
				$.ajax {
					type: 'GET'
					url: "/calendar/show_form/#{event.id}"
					async: false
					dataType: 'html'
					contentType: 'application/json'
					success: (data, textStatus, xhr) ->
						if xhr.status == 200
							popoverController::inside_popover_show = data
						return
					error: () ->
						console.log 'Error!!'
						return
				}
				init_popover_show_options = {
					html: true
					content: () ->
						return popoverController::inside_popover_show
					container: 'body'
					trigger: 'manual'
				}
				windowWidth = $(window).width()
				thisLeft =  $('#'+this.popover_id).offset().left + $('#'+this.popover_id).width()
				if  windowWidth - thisLeft < 250
					init_popover_show_options.placement = 'left'
				$('#'+this.popover_id).popover(init_popover_show_options).popover 'show'
				$('#'+this.popover_id).addClass('popver-created')
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
			url: '/calendar/new_form'
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


	close_event: () ->
		$.ajax {
			type: 'PUT'
			url: '/users/'+ user_id + '/events/' +  popoverController::popover_id + '/close/'
			data: { cl: "ose" }
			success: (data) ->
				popoverController::hide()
				popoverController::event.color = Calendar.closedEventColor
				$(window.Calendar.calendar_selector).fullCalendar('updateEvent', popoverController::event);
		}
		return

	reopen_event: () ->
		$.ajax {
			type: 'PUT'
			url: '/users/'+ user_id + '/events/' +  popoverController::popover_id + '/reopen/'
			data: { cl: "ose" }
			success: (data) ->
				popoverController::hide()
				popoverController::event.color = Calendar.myEventColor
				$(window.Calendar.calendar_selector).fullCalendar('updateEvent', popoverController::event);
		}
		return

