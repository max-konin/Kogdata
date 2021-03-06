window.create_message = () ->
  conv_id = window.location.toString().split('/')[4]
  $("#send-message-button-for-list").attr('disabled', true)
  $.ajax {
    type: "POST"
    url: "/conversations/create_message?id=#{conv_id}"
    data: {
      message: {
        body: $("#send-message-input").val()
      }
    }
    success: (responce) ->
      $(".list_box").append(responce)
      $("#send-message-button-for-list").attr("disabled", false)
  }

window.delete_message = (parent, id) ->
  $.ajax {
    type: "DELETE",
    url: "/conversations/delete_message/#{id}"
    data: {
      t: "delete"
    }
    success: () ->
      $(parent).remove()
  }
