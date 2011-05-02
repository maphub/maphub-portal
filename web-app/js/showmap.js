$(document).ready(function(){
  
  var locked = false;
  
  $("#detailInfoFollowing").hide();
  
  $("#detailInfo").mouseenter(function(){ showInfo(); });
  
  $("#detailInfo").mouseleave(function(){ hideInfo(); });
  
  $("#detailInfo").click(function(){ 
    locked ? locked = false : locked = true; 
  });
  
  function hideInfo() {
    if (locked == false) {
      $("#detailInfoFollowing").slideUp();
    }
  }
  
  function showInfo() {
    if (locked == false) {
      $("#detailInfoFollowing").slideDown();
    }
  }
  
});