/* This class enables click handlers for various actions */

MapHub.AnnotationUserInteraction = function() {
  
  // hide annotation bar by default
  $("#slideUpBar").hide();
  
  // show it when it
  $("#createNewAnnotation").click(function(){
    $("#annotation_title").attr("value", "");
    $("#annotation_body").attr("value", "");
    $("#slideUpBar").slideDown(function(){
      $("#annotation_title").focus();
    });
  });
  
  // cancel editing an annotation
  $("#buttonCancel").click(function(){
    $("#slideUpBar").slideUp();
  });
  
}