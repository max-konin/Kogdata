#= require dateFormat
#= require Calendar/fullcalendar
#= require bootstrap-tooltip
#= require bootstrap-popover



window.role = $.cookie 'role'
window.user_id = 0
window.event_title = { todo: "global" }
window.event_description = { todo: "global" }
window.event_start = {todo: "global"}
window.inside_popover_new = {todo: "global"}
window.Popover = {todo: "global"}
