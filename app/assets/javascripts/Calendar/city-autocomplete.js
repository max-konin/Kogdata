$("#tags").autocomplete({
    source: function(request,response) {
        var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
        response( $.grep( window.city, function( item ){
            return matcher.test( item );
        }) );
    }
})