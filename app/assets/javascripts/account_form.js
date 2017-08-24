// if(document.getElementById("account_person_type_natural").checked) {
//   $('#natural-info').show();
//   $('#legal-info').hide();
// }
// else(document.getElementById("account_person_type_legal").checked) {
//   $('#legal-info').show();
//   $('#natural-info').hide();
// };

// en fait là avec du simple javascript, on ne peut pas réagir de toute façon de façon dynamique à l'action de l'utilisateur
// mais je ne comprends pas cependant pourquoi cela impacte le fonctionnement de ma navbar
// pourquoi cela marche de tems en temps et qu'à d'autres il me dit même que .show et .hide ne sont pas des méthodes ad'hoc....

// $(document).ready(function() {

//   $('input[name="person_type"]').change(function() {
//       var selected = $('input:checked[name="person_type"]').val();
//       if(selected == 'NATURAL') {
//           $('#natural-info').hide();
//           $('#legal-info').show();
//       } else if(selected == 'lLEGAL') {
//           $('#legal-info').hide();
//           $('#natural-info').show();
//       }
//   });
// };


// $( "input" ).on( "click", function() {
//   $( "#log" ).html( $( "input:checked" ).val() + " is checked!" );
// });

// $('input[name="post[is_revision"]').change(function() {
//     var selected = $('input:checked[name="post[is_revision]"]').val();
//     if(selected == 'revision') {
//         $('#title').hide();
//         $('#revision').show();
//     } else if(selected == 'new_post') {
//         $('#revision').hide();
//         $('#title').show();
//     }
// });

// document.querySelectorAll('input[name$="value"]');





//mon événement: dès que qqun clique sur une checkbox alors, cela execute la fonction showTheRightFiels
$(document).ready(function() {
  $( "input[type=checkbox]" ).on( "click", function() {
    if(document.getElementById("account_person_type_natural").checked) {
      $('#natural-info').show();
      $('#legal-info').hide();
    }
    else(document.getElementById("account_person_type_legal").checked) {
      $('#legal-info').show();
      $('#natural-info').hide();
    };
  });
});

