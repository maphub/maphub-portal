$(document).ready(function(){
  $(".edit_user").hide();
  // If the "Edit your description button" is clicked
  $("#toggle-form").click(function(){
    $('#about-myself').hide();
    $(".edit_user").slideDown(function(){
      $("#user_about_me").focus();
    });
    return false;
  });
  $("#button-cancel").click(function(e){
    e.preventDefault();
    $(".edit_user").slideUp(function(){
      $('#about-myself').show();
    });
  });

});