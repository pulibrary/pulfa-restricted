$(function () {

   $('body').prepend('<a href="#" class="back-to-top">Back to Top</a>');

   var amountScrolled = $('#dsc').position().top - 65;

    $(window).scroll(function() {
    	if ( $(window).scrollTop() > amountScrolled ) {
    		$('a.back-to-top').fadeIn('slow');
    	} else {
    		$('a.back-to-top').fadeOut('slow');
    	}
    });      
        
    $('a.back-to-top').click(function() {
	$('html, body').animate({
    	scrollTop: $('#dsc').position().top - 65 // 0
    	}, 700);
        return false;
    }); 
    
    
    $( ".access-label" ).click(function(e) {
      e.preventDefault();
      $( this ).next().toggle( "slow" );
    });
    
    
});