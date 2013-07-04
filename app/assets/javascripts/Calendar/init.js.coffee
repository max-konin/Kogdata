#= require dateFormat
#= require fullcalendar
#= require bootstrap-tooltip
#= require bootstrap-popover



window.role = $.cookie 'role'
window.user_id = $.cookie 'user_id'
window.event_title = { todo: "global" }
window.event_description = { todo: "global" }
window.event_start = {todo: "global"}
window.inside_popover_new = {todo: "global"}
window.Popover = {todo: "global"}
