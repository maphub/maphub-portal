maphub.ManualTaggingView = function(callback_url, timeout) {
  this.callback_url = callback_url;
  this.timeout = timeout;
  this.tags = new Array();
  this.status = "idle";
  
  // store the function for later
  var self = this; 
  window.tagging_view = this;
  
  // after waiting, create the tags
  //$("#modal-annotation-tags").empty();
  $("#manual-tag-entry").keyup(function(){
    $(this).doTimeout('manual-timeout', self.timeout, function(){
      
      // get text to submit to controller
      var text = encodeURIComponent($("#manual-tag-entry").val().replace(/[^\w\s,]/gi, ''));
      console.log(text);
      if(!(text === "") || (text != "Add your annotation here!")) {
        if (self.status != "loading") {        
          // main request sent to controller
          var request = self.callback_url           + "?"
            + "text="             + text            + "&" 
            + "annotation[boundary][ne_x]="   + $("#annotation_boundary_attributes_ne_x").val()  + "&"
            + "annotation[boundary][ne_y]="   + $("#annotation_boundary_attributes_ne_y").val()  + "&"
            + "annotation[boundary][sw_x]="   + $("#annotation_boundary_attributes_sw_x").val()  + "&"
            + "annotation[boundary][sw_y]="   + $("#annotation_boundary_attributes_sw_y").val()
            ;
        
          $("#no-tags").hide();
          $("#loading-tags").show();
          self.status = "loading";
        
          // fetch tags for this text
          $.getJSON(request, function(data) {
          
            $("#loading-tags").hide();
            $("#tagging-help").fadeIn("slow");
          
            // iterate over every tag received
            $.each(data, function(key, val) {
              // returned tags are in val, with their attributes
              var label = val.label;
              var dbpedia_uri = val.dbpedia_uri;
              var description = val.description;
            
              // if the tag doesn't exist yet
              if (self.tags[label] === undefined) {
              
                // create new tag element
                var tag = $(document.createElement('span'));
                // set style (label)
                tag.attr("class", "label label-neutral");
                tag.text(label);
                // link it
                var linked_tag = $(document.createElement('a'));
                //linked_tag.attr("href", dbpedia_uri);
                //linked_tag.attr("href", "#");
                //linked_tag.attr("target", "_blank");
                linked_tag.attr("rel", "tooltip");
                linked_tag.attr("title", description);
                linked_tag.html(tag)
                // append to the form
                linked_tag.appendTo($("#modal-annotation-tags"));


                // // create hidden input fields to pass on data
                var input_container = $(document.createElement('div'));
                input_container.attr("class", "tag-fields");

                var input_label = $(document.createElement('input'));
                input_label.attr("type", "text");
                input_label.css("display", "none");
                input_label.attr("name", "label[]");
                input_label.attr("value", label);
                input_label.appendTo(input_container);

                var input_dbpedia_uri = $(document.createElement('input'));
                input_dbpedia_uri.attr("type", "text");
                input_dbpedia_uri.css("display", "none");
                input_dbpedia_uri.attr("name", "dbpedia_uri[]");
                input_dbpedia_uri.attr("value", dbpedia_uri);
                input_dbpedia_uri.appendTo(input_container);

                var input_description = $(document.createElement('input'));
                input_description.attr("type", "text");
                input_description.css("display", "none");
                input_description.attr("name", "description[]");
                input_description.attr("value", description);
                input_description.appendTo(input_container);

                var input_status = $(document.createElement('input'));
                input_status.attr("type", "text");
                input_status.css("display", "none");
                input_status.attr("name", "status[]");
                input_status.attr("value", "neutral");
                input_status.appendTo(input_container);

                input_container.appendTo($("#modal-annotation-tags"));

                // add the tags objects to the javascript view 
                // so we can manipulate them
                self.tags[label] = val;

                // toggle accepted / rejected / neutral
                tag.click(function() {
                  if ($(this).hasClass("label-neutral")) {
                    $(this).removeClass("label-neutral").addClass("label-success");
                    self.tags[label].status = "accepted";
                    input_status.attr("value", "accepted");
                  } else if ($(this).hasClass("label-success")) {
                    $(this).removeClass("label-success").addClass("label-important");
                    self.tags[label].status = "rejected";
                    input_status.attr("value", "rejected");
                  } else if ($(this).hasClass("label-important")) {
                    $(this).removeClass("label-important").addClass("label-neutral");
                    self.tags[label].status = "neutral";
                    input_status.attr("value", "neutral");
                  }
                }); // end click handler for tags
              } // end if tag exists
            
            }); // end each iteration for returned tags
            self.status = "idle";
          }); // end get JSON request
        }
      } // end check whether input text is empty
    }); // end timeout function
  }); // end keyup function
} // end tagging view

// resets the internal structure of the tagging view, i.e. the tags it remembered
maphub.TaggingView.prototype.reset = function() {
  this.tags = new Array();
}
