#= require ../partial
#= require ./response_list

###
Object of event list in own user page
###
class @EventList extends Partial

  constructor: (options) ->
    ###
    Object of event elem UserEdit class
    ###
    @event_elem = null

    ###
    DOM elem of selected item in EventList
    ###
    @event_list_elem = null

    ###
    Object of response list ResponseList class
    ###
    @response_list = null
    ###
    default parameters for each new elem of this class
    ###
    @options =
    # Parent id elem for this class
      event_list_id: '#event_list'
    # id of child elem UserEvent class
      event_elem_id: '#event'
    # id of child elem ResponseList class
      response_list_id: '#responses'
      fit_partial: null
      data : null
      on_success: null

    @btn =
      events: '.show_event_link'
      responses: '.show_responses_link'

    @get_options(options)
    return



  get_options: (options) ->
    # Creating local parameters for currents instance of class
    if !options
      return
    # Setup default or custom option of each elem from _options
    if options
      for elem of @options
        if options[elem]
          @options[elem] = options[elem]
    return

  ###
  This method create parent popover elem for content from server response
  @param options - parameters for function
  | elem_id - div id, wich will be created in  parent_id
  | parent_id - id parent element
  | parameters from _popover_opt for overwriting
  | offset_elem - need than window width is less than 767px
  ###
  prepend_popover_window: (options) ->
    if !$( options.parent_id).length
      throw 'Can\'t insert element in undefined'

    if $( options.elem_id).length
      return

    _popover_opt = {
      'height': 'auto'
      'width' : '340px'
      'z-index' : 1
      'position' : 'absolute'
    }
    # Overwrite parameters in _popover_opt by options
    for elem of _popover_opt
      if options[elem]
        _popover_opt[elem] = options[elem]

    div_elem = $('<div></div>').attr('id', options.elem_id.substring(1)).css(_popover_opt)

    $(options.parent_id).prepend(div_elem)
    # Function to set position for div elem
    popover_position = () ->
      window_size = Object
      window_size = {
        width: document.body.clientWidth
        height: document.body.clientHeight
      }

      if window_size.width <= 767 # Width from bootstrap
        if options.offset_elem
          offset_elem = $(options.offset_elem).offset()
          offset_div = offset_elem

          if offset_elem.left + div_elem.outerWidth() > window_size.width
            offset_div.left = window_size.width - 20 - div_elem.outerWidth()

          if offset_elem.top + div_elem.outerHeight() > document.height
            offset_div.top = window_size.height - 20 - div_elem.outerHeight()

          div_elem.offset(offset_div)
      else
        parent_pos = $(options.parent_id).offset()
        elem_left = parent_pos.left + $(options.parent_id).outerWidth() + 20
        elem_top = parent_pos.top

        if elem_left + div_elem.outerWidth() > window_size.width
          elem_left = window_size.width - div_elem.outerWidth() - 20

        if elem_top + div_elem.outerHeight > window_size.height
          elem_top = window_size.height - div_elem.outerHeight

        div_elem.offset({
          left: elem_left
          top: elem_top
        })
      return
    popover_position()
    $(window).resize(popover_position)
    $(div_elem).on('remove', ()->
      $(window).unbind(popover_position)
      return
    )
    return

  ###
  Bind click listener on event list block.
  By clicking on btn.events button show clicked event modal window
  Using UserEvent class elem for show event
  ###
  bind_show_event: () =>
    event_list = this
    $(@options.event_list_id).on('click', @btn.events, (e) ->
      # Get event id from button attr
      event_id = $(this).attr('event_id')
      if !event_id
        # take text id from first cell or row
        event_id = $(e.target).html().trim()

      # Init options for Event object
      options =
      {
        event_elem_id: event_list.options.event_elem_id
        close_button: true
        on_success: () ->
          # Select item in orders list
          event_list.event_list_elem = $(e.target).parents('tr').first()
          event_list.event_list_elem.addClass('info')
          return
        on_destroy: () ->
          if !event_list.event_list_elem
            return
          # Unselect item in orders list
          event_list.event_list_elem.removeClass('info')
          event_list.event_list_elem = null
          event_list.event_elem = null
          $(event_list.options.event_elem_id).remove()
          return
        on_delete: () ->
          if !event_list.event_list_elem
            return
          # Delete elem from orders list
          event_list.event_list_elem.remove()
          event_list.event_list_elem = null
          event_list.event_elem = null
          $(event_list.options.event_elem_id).remove()
          return
      }

      if event_list.response_list
        event_list.response_list.destroy()
        event_list.response_list = null

      if event_list.event_elem
        event_list.event_elem.destroy()

      event_list.prepend_popover_window({
        parent_id: event_list.options.event_list_id
        elem_id: event_list.options.event_elem_id
        offset_elem: e.target
      })

      event = new UserEvent(options)
      event_list.event_elem = event
      event.init(event_id)
      return false
    )
    return

  ###
  Init UserEvent object for show reponse list
  ###
  bind_show_responses: () =>
    event_list = this
    $(@options.event_list_id).on('click', @btn.responses, (e) ->
      # Get event id from button attr
      event_id = $(this).attr('event_id')
      if !event_id
        td = $(e.target).parent('tr').
        event_id = $(e.target).html().trim()

      # Init options for Event object
      options =
      {
        event_elem_id: event_list.options.event_elem_id
        close_button: true
        on_success: () ->
          # Select item in orders list
          event_list.event_list_elem = $(e.target).parents('tr').first()
          event_list.event_list_elem.addClass('info')
          return
        on_destroy: () ->
          # Unselect item in orders list
          event_list.event_list_elem.removeClass('info')
          event_list.event_list_elem = null
          event_list.response_list = null
          $(event_list.options.response_list_id).remove()
          return
        on_delete: () ->
          # Delete elem from orders list
          event_list.event_list_elem.remove()
          event_list.event_elem = null
          return
      }

      if event_list.event_elem
        event_list.event_elem.destroy()
        event_list.event_elem = null

      if event_list.response_list
        event_list.response_list.destroy()
        event_list.response_list = null

      event_list.prepend_popover_window({
        parent_id: event_list.options.event_list_id
        elem_id: event_list.options.response_list_id
        'width': '540px'
        offset_elem: e.target
      })

      respone_list = new ResponseList(options)
      event_list.response_list = respone_list

      respone_list.init(event_id)
      return false
    )
    return

  ###
  Load partial with list orders from server and bind event listener on needed buttons
  ###
  init: (user_id, options) ->
    @get_options(options)
    @get_partial("/users/#{user_id}/events.html", @options.event_list_id,{
      data: @options.data
      on_success: () =>
        if @options.on_success
          @options.on_success()
        @bind_show_event()
        @bind_show_responses()
        table = $(@options.event_list_id).find('table').first()
        paginator = @table_paginator(table)
        $(@options.event_list_id).find('> div').first().append(paginator)
        return
      #fit_partial: @options.fit_partial
    })
    return

  ###
  Function wich call before destroy object for correctly work application
  Than EventList is destring, calling destroy methods to child objects
  ###
  destroy: () ->
    if @event_elem
      @event_elem.destroy()

    if @response_list
      @response_list.destroy()

    $(@options.event_list_id).empty()
    return