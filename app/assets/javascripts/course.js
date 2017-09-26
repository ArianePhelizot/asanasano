
$(document).ready(function() {
  $('#uncomplete-course-desc').on("click", function() {
    $('#uncomplete-course-message').toggleClass("hidden");
  });
});

$(document).ready(function() {
  $('#course-with-slots').on("click", function() {
    $('#course-with-slots-message').toggleClass("hidden");
  });
});

$(document).ready(function() {
  $('#more-info').on("click", function() {
    $('#more-course-info').toggleClass("hidden");
  });
});
