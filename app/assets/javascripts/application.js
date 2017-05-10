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

//= require jquery/jquery-3.1.1.min.js
//= require bootstrap-sprockets
//= require touchspin/jquery.bootstrap-touchspin.min.js
//= require chosen/chosen.jquery.js
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require slimscroll/jquery.slimscroll.min.js
//= require ladda/spin.min.js
//= require ladda/ladda.min.js
//= require ladda/ladda.jquery.min.js
//= require dataTables/datatables.min.js
//= require validator/validator.min.js
//= require jquery.peity.min.js
//= require sweetalert/sweetalert.min.js

//= require_tree .

$(document).ready(function () {
    $.get('/queue/loadqueue');

    $('#newquote').on('click', function () {
        $.get('/home/newquote');
        $("#quotepartial").validator('update');
        $("#queuewrapper").css('display', 'none');
    });
    
    $("#quotepartial").validator();
 
    $('#createsow').submit(function (e) {
        e.preventDefault();
        //if (!e.isDefaultPrevented()) {
            $.post($(this).action, $(this).serialize(), null, 'script');  
            return false;  
        //}
    }); 
    
    $('#quotepartial').submit(function (e) {
        sweetAlert('foo');
    });
    
    $('#quotebutton').click(function (e) {
        
        if (!e.isDefaultPrevented()) {
            if ($('#agarea').html() != "" || $('#idadminarea').html() != "" || $('#msarea').html() != "")
                {
                    //if (!e.isDefaultPrevented()) {
                        $.post('quote/hours', $('#quotepartial').serialize(), null, 'script');  
                        return false;  
                    //}
                } else {
                    e.preventDefault();
                }
        }; 
    });
    
    $( "body" ).on( "click", ".collapse-link", function() {       
        var ibox = $(this).closest('div.ibox');
        var button = $(this).find('i');
        var content = ibox.find('div.ibox-content');
        content.slideToggle(200);
        button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
        ibox.toggleClass('').toggleClass('border-bottom');
        setTimeout(function () {
            ibox.resize();
            ibox.find('[id^=map-]').resize();
        }, 50);
    });
    
    $("body").on('click', "#full", function () {
        $('#full').addClass('btn-primary');
        $('#full').removeClass('btn-white');
        $('#quick').removeClass('btn-primary');
        $('#quick').addClass('btn-white');
        $('.quickgroup').show();
    });

    $("body").on('click', "#quick", function () {
        $('#quick').addClass('btn-primary');
        $('#quick').removeClass('btn-white');
        $('#full').removeClass('btn-primary');
        $('#full').addClass('btn-white');
        $('.quickgroup').hide();
    });
    
 
    $(".helpmsg").tooltip();
    
    /*var l = $( '.ladda-button-demo' ).ladda();
    l.click(function(){

          // Start loading
          l.ladda( 'start' );

          // Do something in backend and then stop ladda
          // setTimeout() is only for demo purpose
          setTimeout(function(){
              l.ladda('stop');
          },2000)

      });*/
    
});