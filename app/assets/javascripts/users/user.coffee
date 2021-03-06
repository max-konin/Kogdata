#= require ../partial
#= require ./portfolio
#= require ./order
#= require ./event_list
#= require ./user_edit
#= require ./conversations


###
Abstract basic model of user contain all methods needed for users
extends by partial to load rartials from server
###
class @User extends Partial

  constructor: ->
    # Hide button, then raprial is loaded
    @is_buttons_hide = true
    # Global class param: add close button on loaded partials.
    @with_close_button = false
    # List for contain initalize objects for left, right, bottom blocks
    @block =
      bottom: null
      left: null
      right: null

    # List for contain block id's for wich crated block objects
    @block_id =
      bottom: "#bottom_block"
      left: "#left_block"
      right: "#right_block"
      user_info : '#user_info_block'

    # Butons for wich bindings call functions
    @btn =
      # On photograph own page
      calendar: '#calendar_button'
      # On user page
      message: '#message_button'
      # On photograph page
      portfolio: '#portfolio_button'
      # On personal user page
      user_edit: '#user_edit_button'
      # On personal client page
      event: '#my_events_button'
      # On personal photograph page
      order: '#my_orders_button'

    return

  get_options: (options, _options) ->
    if options
      for elem of _options
        if options[elem]
          _options[elem] = options[elem]
    return



  ###
  Show all buttons from btn list and hide needed button
  @param button_to_hide - id or dom object button, wich needed to hide
  ###
  hide_buttons: (button_to_hide) ->
    if @is_buttons_hide == false
      return
    $(button).show() for name, button of @btn

    if button_to_hide
      $(button_to_hide).hide()
    return


  # Init message controller
  messages: () ->
    if @block.right
      @block.right.destroy()
      options = {
        parent_id: @block_id.right
      }
    conversations = new Conversations(options)
    @block.right = conversations
    conversations.init()

    return

  # Return info about photorgapher or client from server
  info: (_user_id) ->
    if @block.right
      @block.right.destroy()
      @block.right = null

    if !_user_id
      _user_id = $(@btn.portfolio).attr('user_id')

    if !_user_id
      console.log "user id not set"
      return

    this.get_partial("/users/#{_user_id}.html", @block_id.right)
    return

  ###
  Initialize calendar on photograph page
  @param with_close - if true, close button will be added
  ###
  calendar: (with_close = false) ->

    # Clear left block
    if @block.right != null
      @block.right.destroy()
      @block.right = null

    calendar = $('<div></div>').addClass('back_white_box parent').
    append($('<div></div>').attr('id', 'calendar'))
    nav = $('<div></div>').attr('id', 'navigation')
    $(@block_id.right).html(calendar, nav)
    $(@block_id.right).append(nav)

    if @with_close_button || with_close
      this.add_close_button(calendar, Calendar)

    user = this
    # Add destroy method for calendar
    if !Calendar.destroy
      Calendar.destroy = ->
        $(user.block_id.right).empty()
        user.block.right = null
        return

    if Calendar.calendar_init
      Calendar.calendar_init()
    @block.right = Calendar

    return

  ###
  # Add remove icon, and bind function destroy() object
  # @param dom_obj - parent id elem, or jquery dom object in wich close button will added
  # @param object - Object elem wich needed to destroy or callback method
  # if object set then on close click calling object method destroy()
  ###
  add_close_button: (dom_obj, object) ->
    on_close = () ->
      if typeof object == 'function'
        object()
      else
      if object and object.destroy
        object.destroy()
      else
        $(dom_obj).empty()
      return
    i = $('<i></i>').addClass('icon-remove pointer').on('click', on_close)
    i = $('<div></div>').addClass('to_right').append(i)
    $(dom_obj).prepend(i)
    return

  ###
  # Init portfolio object and load images list from server
  ###
  portfolio: () ->
    # Get user id from attr button
    user_id = $(@btn.portfolio).attr('user_id')
    if !user_id
      console.log "user id not set"
      return
    portfolio = new Portfolio()
    options =
    {
      parent_id: @block_id.bottom
    }
    # Clear bottom block controller
    if @block.bottom != null
      @block.bottom.destroy()
      @block.bottom = null
    @block.bottom = portfolio
    portfolio.init(user_id, options)
    return

  ###
  # Init order object for orders list and load orders form server
  ###
  orders: () ->
    # Get user id from attr button
    user_id = $(@btn.order).attr('user_id')
    if !user_id
      console.log "suer id not set"
      return
    order = new Order()
    on_success = =>
      # Clear right block controller
      if @block.right != null
        @block.right.destroy()
      @block.right = order
      return

    options =
    {
      on_success: on_success()
      order_elem_id: @block_id.right
      event_elem_id: @block_id.left
    }
    order.init(user_id, options)
    return

  ###
  # Init UserEdit object for bind events on user edit form
  ###
  user_edit: () ->
    user_edit = new UserEdit()
    # Clear bottom block controller
    if @block.right != null
      @block.right.destroy()
    @block.right = user_edit

    options =
    {
      form_parent_id: @block_id.right
    }
    user_edit.init(options)
    return

  ###
  # Init events
  ###
  events: (options) ->
    events = new EventList()
    user_id = $(@btn.event).attr('user_id')
    if !user_id
      console.log "user id no set"

    _options =
    {
      event_list_id: @block_id.left
      fit_partial: {
        bottom_elem: '#footer'
      }
      data: null
    }
    this.get_options(options, _options)
    # Clear bottom block controller
    if @block.left != null
      @block.left.destroy()
    @block.left = events

    events.init(user_id, _options)
    return
  #TODO: what whis? if events will shown in right block or modal window.
  destroy_events: () ->
    if @block.left != null
      @block.left.destroy()
    return

