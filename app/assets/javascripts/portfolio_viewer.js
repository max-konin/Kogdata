/**
 * Created with JetBrains RubyMine.
 * User: Mitya
 * Date: 11.06.13
 * Time: 13:30
 * To change this template use File | Settings | File Templates.
 */

//= require jquerypp.custom
//= require jquery.elastislide
function carousel_init()
{
    // example how to integrate with a previewer
	$( '#carousel').elastislide();
	/*
	var current = 0,
        $preview = $( '#preview' ),
        $carouselEl = $( '#carousel' ),
        $carouselItems = $carouselEl.children(),
        carousel = $carouselEl.elastislide( {
            current : current,
            minItems : 4,
            onClick : function( el, pos, evt ) {
                changeImage( el, pos );
                evt.preventDefault();
            },
            onReady : function() {

                changeImage( $carouselItems.eq( current ), current );


            }
        } );

    function changeImage( el, pos ) {

        $preview.attr( 'src', el.data('preview' ) );
        console.log(el);
        var a;
        $preview.attr( 'src', a );
        $carouselItems.removeClass( 'current-img' );
        el.addClass( 'current-img' );
        carousel.setCurrent( pos )

    }  */
}
carousel_init();
