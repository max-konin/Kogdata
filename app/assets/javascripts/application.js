// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require fullcalendar
//= require_tree .

$(document).ready(function() {

    // page is now ready, initialize the calendar...

    $(document).ready(function() {


        var date = new Date();
        var d = date.getDate();
        var m = date.getMonth();
        var y = date.getFullYear();
        change_event = function(_event, delta) {
            console.log("evento" + _event.id);
            $.ajax({
                url: "events/"+_event.id+'.json',
                data: {event:{id:_event.id,start:_event.start,end: _event.end}},
                method: 'PUT' ,
                datatype: 'JSON',
                error: function(jqXHR, textStatus, errorThrown) {
                    console.log(textStatus);
                },
                success: function(data) {
                    console.log('event was success updated');
                }
            });
        }
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay',
                prev: 'circle-triangle-w',
                next: 'circle-triangle-e'
            },
            editable: true,
            events: "events/",
            eventResize: change_event,
            eventDrop: change_event ,

            loading: function(bool) {
                if (bool) $('#loading').show();
                else $('#loading').hide();
            }
        });

        $(".iframe").fancybox({
            "type":"iframe",
            "width": 800,
            "height": 600,
            "scrolling": 'no',
            "titleShow": false,
            'afterClose': function(){

                //$('#calendar').fullCalendar('removeEvents')
                //$('#calendar').fullCalendar('addEventSource', "events/");
                $('#calendar').fullCalendar('refetchEvents');
                //$('#calendar').fullCalendar('rerenderEvents')
                console.log('render compleate');

            }
        });
    });

});