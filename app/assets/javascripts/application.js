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
//= require RailsAjax-Config
//= require fullcalendar
//= require_tree .

    // page is now ready, initialize the calendar...


    // List of events
    arrayOfEvents=[];
    $(document).ready(function() {


        var eObj1=$('#external-events div.external-event').data;
        eObj1.start =  "Mon May 13 2013 00:00:00 GMT+0700(N. Central Asia Standard Time)";
        eObj1.title = 'Hello';
        arrayOfEvents.push(eObj1);

        InputTitle = document.getElementById('EventTitle');
        InputTitle.onchange = function() {

        };

        InputText = document.getElementById('EventDescription')
        Calendar = document.getElementById('calendar')

        $('#external-events div.external-event').each(function() {

            // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
            var eventObject = $(this).data() // use the element's text as the event title


            //make a copy of Event Object
            var copiedEventObject;
            copiedEventObject = $.extend({},eventObject);
            arrayOfEvents.push(copiedEventObject);

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
                        copiedEventObject.Description = InputTitle.value;
                        data= 'title=' + copiedEventObject.title + 'start='+copiedEventObject.start+'description='+copiedEventObject.description;
                        $.ajax('/events/new',
                        {
                            type: "POST",
                            contentType: 'application/json',
                            success: function(){

                            }
                        });
                        // render the event on the calendar
                        // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
                        $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);

                        // is the "remove after drop" checkbox checked?
                        if ($('#drop-remove').is(':checked')) {
                            // if so, remove the element from the "Draggable Events" list
                            $(this).remove();
                    };}

                }
            });

    });
