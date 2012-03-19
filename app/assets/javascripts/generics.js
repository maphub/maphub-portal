$(document).ready(function(){
  
  // hides all elements with the .hiddenElement class
  $(".hiddenElement").hide();

  // Enables a generic slide down effect
  // Elements with .hiddenElement will be hidden by default and toggled by the .slideDown button.
  //
  // The trigger needs to have the .slideDown class
  // The target needs to have the .hiddenElement class and be a sibling of the trigger
  $(".slideDown").each(function(){
    // will be styled as anchor
    $(this).html("<a>" + $(this).html() + "</a>");
  });
  $(".slideDown").click(function(){
    $(this).siblings(".hiddenElement").slideDown(function(){ $(this).focus(); });
  });
  
  // Enables a generic slide down effect
  // The next element to the .foldable trigger will be hidden
  $(".foldable").each(function(){
    // will be styled as anchor
    $(this).html("<a>" + $(this).html() + "</a>");
  });
  $(".foldable").next().hide();
  $(".foldable").click(function(){
    $(this).next().slideToggle();
  });
  
  
  $(".edit-user").hide();
  
  // If the "Edit your description button" is clicked
  $("#toggleForm").click(function(){
    $('#aboutMyself').hide();
    $(".edit_user").slideDown(function(){
      $("#user_about_me").focus();
    });
    return false;
  });
});