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

    // page is now ready, initialize the calendar...


    // List of events
    arrayOfEvents=[];
    $(document).ready(function() {

        InputTitle = document.getElementById('EventTitle');
        InputTitle.onchange = function() {

        };

        InputText = document.getElementById('EventDescription')
        Calendar = document.getElementById('calendar')

        $.ajax({
            url:"/events/all.json",
            dataType:'json',
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
                    right: 'month,agendaWeek,agendaDay',
                    prev: 'circle-triangle-w',
                    next: 'circle-triangle-e'
                },
                editable: true,
                droppable: true,
                events: function(start, end, callback)
                {
                    callback(arrayOfEvents);
                },
                eventDrop: function(event,dayDelta,minuteDelta,allDay,revertFunc)
                {
                    var EventObject = event;
                    var request = {title: EventObject.title,start:EventObject.start,description:
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
                        copiedEventObject.start = date;
                        copiedEventObject.allDay = allDay;
                        copiedEventObject.title = InputTitle.value;
                        copiedEventObject.description = InputText.value;

                        console.log($('#calendar').fullCalendar('getDate'));
                        request = {title: copiedEventObject.title,start:copiedEventObject.start,description:
                            copiedEventObject.description};
                        //request = JSON.stringify(request);
                        $.ajax({
                            url:"/events/new.json",
                            contentType:'application/json; charset-utf8',
                            dataType:'json',
                            data:{events: request},
                            success:function(response){
                                var events = response;
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

                       /* $.getJSON('/events/new.json',
                        function(data1,data2,data3){
                            alert(data3)
                        }); */
                        // render the event on the calendar
                        // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)

                    }}



            });

    });
