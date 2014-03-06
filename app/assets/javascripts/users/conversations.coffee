###
Conversations class for operate with conversations list and conversations dialogs
This class contain ajax method for getting partial from server
###
class @Conversations extends Partial

  constructor: (options) ->
    # contain bind function pointer
    @conversations_list_click = null
    @options =
      parent_id: null
      conversation_list_elem: '.conversation_box'

    this.get_options(options)
    return

  # Update default options from outsize in init and constructor methods
  get_options: (options) ->
    if options
      for elem of @options
        if options[elem]
          @options[elem] = options[elem]
    return

  bind_conversations_list_click: () ->
    @conversations_list_click = $(@options).on('click', @options.conversation_list_elem, () ->
      conversation_id = $(this).attr('data-conversation-id')
      if !conversation_id
        throw 'Conversation id not found'

    #TODO create conversations functions

      return
    )
    return

  # Init conversation dialog. Load partial from server and bind need functions
  conversation: (conversation_id, options) ->
    if !conversation_id
      throw 'Conversation id not found'

    this.get_options(options)
    if !options
      options = Object

    this.get_partial('/conversations.html', @options.parent_id, {on_success : () ->
      if options.on_success
        options.on_success()
    })

    return

  # Initialize conversation: load html partial with conversation list from server
  init: (options) ->
    this.get_options(options)
    if !options
      options = Object

    this.get_partial('/conversations.html', @options.parent_id, {on_success : () ->
      if options.on_success
        options.on_success()
    })
    return

  destroy: () ->
    $(@options.parent_id).empty()
    return