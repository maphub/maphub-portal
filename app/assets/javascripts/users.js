$(document).ready(function(){
  $(".edit_user").hide();
  // If the "Edit your description button" is clicked
  $("#toggleForm").click(function(){
    $('#aboutMyself').hide();
    $(".edit_user").slideDown(function(){
      $("#user_about_me").focus();
    });
    return false;
  });
  $("#button-cancel").click(function(e){
    e.preventDefault();
    $(".edit_user").slideUp(function(){
      $('#aboutMyself').show();
    });
  });

});