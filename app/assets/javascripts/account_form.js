$(document).ready(function() {
  // $( "input[type=radio]" ).on( "change", function() {
  $('input:radio[name="account[person_type]"]').change(function () {
    // alert ("in!");

    if ( $('input:radio[name="account[person_type]"]:checked').val() == "NATURAL" ) {
       $('#natural-info').show();
       $('#legal-info').hide();
     } else {
       $('#legal-info').show();
       $('#natural-info').hide();
     };
  });
});



