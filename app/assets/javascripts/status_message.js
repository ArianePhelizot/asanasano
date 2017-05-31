$(document).ready(function() {
  $('#status').on("click", function() {
    $('#status-message').popover();
  });
  $('#status').popover({
       placement : 'right',
       trigger : 'hover'
   });
});
