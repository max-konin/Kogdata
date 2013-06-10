/**
 * Created with JetBrains RubyMine.
 * User: Mitya
 * Date: 06.06.13
 * Time: 19:02
 * To change this template use File | Settings | File Templates.
 */



//= require dateFormat
//= require fullcalendar

$(document).ready(function()
{
    $('#show-bookings').click(function (event)
    {
        event.preventDefault();
        $.ajax({
            url:'/office/all',
            dataType:'json',
            success: function(response){
                events = JSON.parse(response.div_contents.body);
                for (var i=0; i<events.length; i++)
                {
                    $('#calendar').fullCalendar('renderEvent',events[i],true);
                }
            }
        })
    });

    $('#external-events div.external-event').each(function() {
        // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
        var eventObject = $(this).data() // use the element's text as the event title
        //make a copy of Event Object
        var copiedEventObject;
        copiedEventObject = $.extend({},eventObject);
        // store the Event Object in the DOM element so we can get to it later
        $(this).data('eventObject', eventObject);
        // make the event draggable using jQuery UI
        $(this).draggable({
            zIndex: 999,
            revert: true,      // will cause the event to go back to its
            revertDuration: 0  //  original position after the drag
        });

    });

    $('#calendar').fullCalendar({
        header: {
            left: 'prev',
            right: 'next',
            center: 'title',
            prev: 'circle-triangle-w',
            next: 'circle-triangle-e'
        },
        firstDay: 1,
        timeFormat: "%FT%T.%LZ",
        editable: true,
        droppable: true,
        eventDrop: function(event,dayDelta,minuteDelta,allDay,revertFunc)
        {
            var EventObject = event;
            var Start4request = EventObject.start.format('isoDateTime');
            var request = {title: EventObject.title,start:Start4request,description:
                EventObject.description};
            // current date of the calendar
            var currentDate = $('#calendar').fullCalendar('getDate');
            currentDate = currentDate.format('isoDateTime');
            $.ajax({
                url:"/events/update.json",
                dataType: 'json',
                contentType: 'application/json; charset-utf8',
                data: {events:request, id: EventObject.id,curDate:currentDate},
                success:function(){
                },
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    alert("Error: " + errorThrown);
                    revertFunc();
                }
            });
        },
        // this allows things to be dropped onto the calendar !!!
        drop: function(date, allDay) { // this function is called when something is dropped
            if ((InputTitle.value!='') && (InputText.value!=''))
            {
                // retrieve the dropped element's stored Event Object
                var originalEventObject = $(this).data('eventObject');
                // we need to copy it, so that multiple events don't have a reference to the same object
                var copiedEventObject = $.extend({}, originalEventObject);
                // assign it the date that was reported
                copiedEventObject.allDay = allDay;
                copiedEventObject.title = InputTitle.value;
                copiedEventObject.description = InputText.value;
                copiedEventObject.start = date;
                var Start4request = date;
                Start4request = Start4request.format('isoDateTime');
                // current date of calendar
                var currentDate = $('#calendar').fullCalendar('getDate');
                currentDate = currentDate.format('isoDateTime');
                request = {title: copiedEventObject.title,start:Start4request,description:
                    copiedEventObject.description};
                //request = JSON.stringify(request);
                $.ajax({
                    url:"/events/new.json",
                    contentType:'application/json; charset-utf8',
                    dataType:'json',
                    data:{events: request,curDate:currentDate},
                    success:function(response){
                        var events = JSON.parse(response.div_contents.body);;
                        copiedEventObject.id = events.id;
                        $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
                        // is the "remove after drop" checkbox checked?
                        if ($('#drop-remove').is(':checked')) {
                            // if so, remove the element from the "Draggable Events" list
                            $(this).remove();}
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        alert("Error: " + errorThrown);
                    }
                });
            }}
    });
    function updateCalendar()
    {
        var currentDate = $('#calendar').fullCalendar('getDate');
        currentDate = currentDate.format('isoDateTime');
        request = {curDate: currentDate};
        InputTitle = document.getElementById('EventTitle');
        InputText = document.getElementById('EventDescription')
        $.ajax({
            url:"/events/all.json",
            dataType:'json',
            contentType:'application/json; charset-utf8',
            data: request,
            success:function(response){
                events = JSON.parse(response.div_contents.body);
                for (var i=0; i<events.length; i++)
                {
                    $('#calendar').fullCalendar('renderEvent',events[i],true);
                }

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
            }
        });
    }
    $('.fc-button-next').click(function(){
            $('#calendar').fullCalendar('removeEvents');
            //$('#calendar').fullCalendar('next');
            updateCalendar();
        }

    );
    $('.fc-button-prev').click(function()
    {
        $('#calendar').fullCalendar('removeEvents');
        updateCalendar();
    });
    updateCalendar();
});
