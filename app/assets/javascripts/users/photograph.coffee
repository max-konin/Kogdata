#= require ./user
#= require Calendar/Controllers/contractor-busyness-controller

class Photograph extends User

  calendar: () ->
    super

    #add radiogroup to select calendar type only for contractor
    on_success = ->
      $('button[name=options]').click () ->
        unless $(this).hasClass('active')
          window.Calendar.clear()
          if $(this).hasClass('my-calendar-option')
            window.Calendar = new contractorBusynessController
            Calendar.calendar_init()
          if $(this).hasClass('orders-option')
            window.Calendar = new window.showAllEventsController
            Calendar.calendar_init()
      return

    @get_partial('/calendar/get_contractor_navigation.html','#navigation', {on_success: on_success})
    return

  # Bind functions for buttons on photograph page
  bind_buttons_events: () ->
    photograph = this

    # Buttons on personal page
    $(photograph.btn.calendar).click(() ->
      # Clear bottom block for more comfortalbe view calendar
      if photograph.block.bottom != null
        photograph.block.bottom.destroy()
        photograph.block.bottom = null
      photograph.calendar()
      return
    )

    $(photograph.btn.message).click(() ->
      photograph.messages()
      return
    )

    $(photograph.btn.portfolio).click(() ->
      photograph.info()
      photograph.portfolio()
      return
    )

    $(photograph.btn.order).click(() ->
      # Clear bottom block for more comfortalbe view orders
      if photograph.block.bottom
        photograph.block.bottom.destroy()
        photograph.block.bottom = null
      photograph.orders()
      return
    )

    $(photograph.btn.user_edit).click(() ->
      # Clear bottom block for more comfortalbe view edit form
      if photograph.block.bottom
        photograph.block.bottom.destroy()
        photograph.block.bottom = null
      photograph.user_edit()
      return false
    )
    return



  constructor: () ->
    super
    return

window.photograph = new Photograph
$(document).ready () ->
  window.photograph.bind_buttons_events()

