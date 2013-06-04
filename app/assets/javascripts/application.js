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
//= require jquery.ui.all
//= require fullcalendar
//= require_tree .

    $(document).ready(function()
    {
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
                    left: 'prev,next today',
                    center: 'title',
                    prev: 'circle-triangle-w',
                    next: 'circle-triangle-e'
                },
                editable: true,
                droppable: true,
                eventDrop: function(event,dayDelta,minuteDelta,allDay,revertFunc)
                {
                    var EventObject = event;
                    var request = {title: EventObject.title,start:EventObject.start.toJSON,description:
                        EventObject.description};
                    $.ajax({
                        url:"/events/update.json",
                        dataType: 'json',
                        contentType: 'application/json; charset-utf8',
                        data: {events:request, id: EventObject.id},
                        success:function(){
                        },
                        error: function(XMLHttpRequest, textStatus, errorThrown) {
                            alert("Error: " + errorThrown);
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
                        copiedEventObject.start =  new Date(date);
                        console.log(copiedEventObject.start.getMonth());
                        copiedEventObject.allDay = allDay;
                        copiedEventObject.title = InputTitle.value;
                        copiedEventObject.description = InputText.value;
                        var S = copiedEventObject.start;
                        var Start4request = S.toJSON();
                        console.log(Start4request);
                        request = {title: copiedEventObject.title,start:Start4request,description:
                            copiedEventObject.description};
                        //request = JSON.stringify(request);
                        $.ajax({
                            url:"/events/new.json",
                            contentType:'application/json; charset-utf8',
                            dataType:'json',
                            data:{events: request},
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
            var curDate = new Date();
            console.log(currentDate);
            var S = currentDate.toJSON();
            curDate = Date.parse(currentDate);
            console.log(S);
            request = {curDate: S};
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
                    alert("Error: " + errorThrown);
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
