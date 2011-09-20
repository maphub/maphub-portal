/* This class enables click handlers for various actions */

MapHub.AnnotationUserInteraction = function() {
  
  // hide annotation bar by default
  $("#slideUpBar").hide();
  
  // cancel editing an annotation
  $("#buttonCancel").click(function(){
    $("#slideUpBar").slideUp();
  });
  
}