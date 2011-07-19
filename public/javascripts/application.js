// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  
  
  // Enables generic slide down effects.
  // The trigger needs to have the .slideDown class
  // The target needs to have the .hiddenElement class and be a sibling of the trigger
  $(".hiddenElement").hide();
  $(".slideDown").each(function(){
    // will be styled as anchor
    $(this).html("<a>" + $(this).html() + "</a>");
  });
  $(".slideDown").click(function(){
    $(this).siblings(".hiddenElement").slideDown(function(){ $(this).focus(); });
  });
  
});