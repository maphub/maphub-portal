define(['TileOverlay', 'ExtDraggableObject'], function() { 
	maphub.AlphaOverlay = function(parameters) {
		if (parameters) {
			maphub.TileOverlay.prototype.constructor.apply(this, [parameters]);
		}
	};

	maphub.AlphaOverlay.prototype = new maphub.TileOverlay();
	maphub.AlphaOverlay.constructor = maphub.AlphaOverlay;

	maphub.AlphaOverlay.prototype.SliderWidth = 57;
	maphub.AlphaOverlay.prototype.InitialOpacity = 40;
	maphub.AlphaOverlay.prototype.SliderImageURL = '/images/opacity-slider.png';
	
	maphub.AlphaOverlay.prototype.getTile = function(point, zoomLevel, container) {
		console.log("maphub.AlphaOverlay.prototype.getTile");
		var tile = maphub.TileOverlay.prototype.getTile.apply(this, [point, zoomLevel, container]);
		return tile;
	}
	
	function createOpacityControl(map, opacity) {
		var sliderImageUrl = "opacity-slider3d7.png";
		
		// Create main div to hold the control.
		var opacityDiv = document.createElement('DIV');
		opacityDiv.setAttribute("style", "margin:5px;overflow-x:hidden;overflow-y:hidden;background:url(" + maphub.AlphaOverlay.prototype.SliderImageURL + ") no-repeat;width:71px;height:21px;cursor:pointer;");

		// Create knob
		var opacityKnobDiv = document.createElement('DIV');
		opacityKnobDiv.setAttribute("style", "padding:0;margin:0;overflow-x:hidden;overflow-y:hidden;background:url(" + maphub.AlphaOverlay.prototype.SliderImageURL + ") no-repeat -71px 0;width:14px;height:21px;");
		opacityDiv.appendChild(opacityKnobDiv);

		var opacityCtrlKnob = new ExtDraggableObject(opacityKnobDiv, {
			restrictY: true,
			container: opacityDiv
		});

		google.maps.event.addListener(opacityCtrlKnob, "dragend", function () {
			setOpacity(opacityCtrlKnob.valueX());
		});

		google.maps.event.addDomListener(opacityDiv, "click", function (e) {
			var left = findPosLeft(this);
			var x = e.pageX - left - 5; // - 5 as we're using a margin of 5px on the div
			opacityCtrlKnob.setValueX(x);
			setOpacity(x);
		});

		map.controls[google.maps.ControlPosition.TOP_RIGHT].push(opacityDiv);

		// Set initial value
		var initialValue = maphub.AlphaOverlay.prototype.SliderWidth / (100 / opacity);
		opacityCtrlKnob.setValueX(initialValue);
		setOpacity(initialValue);
	}

	maphub.AlphaOverlay.prototype.setOpacity = function(pixelX) {
		// Range = 0 to maphub.AlphaOverlay.prototype.SliderWidth
		var value = (100 / maphub.AlphaOverlay.prototype.SliderWidth) * pixelX;
		if (value < 0) value = 0;
		if (value == 0) {
			if (overlay.visible == true) {
				overlay.hide();
			}
		}
		else {
			overlay.setOpacity(value);
			if (overlay.visible == false) {
				overlay.show();
			}
		}
	}

	function findPosLeft(obj) {
		var curleft = 0;
		if (obj.offsetParent) {
			do {
				curleft += obj.offsetLeft;
			} while (obj = obj.offsetParent);
			return curleft;
		}
		return undefined;
	}

});
