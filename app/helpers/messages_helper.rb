module MessagesHelper
  def new_response_for_event (event_id)
    raise ArgumentError, 'Cannot create response for nil event' if event_id.nil?
    event = Event.find event_id
    message = event.messages.build
  end
end