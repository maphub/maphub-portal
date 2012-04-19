/*
 * Define this class's prerequisites and only set up this class after those
 * prerequisites have been loaded.
 */
define(['TileOverlay', 'ExtDraggableObject'], function() {
	/**
	 * A TileOverlay that includes support for changing the transparency/opacity
	 * of the overlay.
	 */
	maphub.AlphaOverlay = function(parameters) {
		if (parameters) {
			/*
			 * Call super().
			 */
			maphub.TileOverlay.prototype.constructor.apply(this, [parameters]);
		}
		
		this.opacity = maphub.AlphaOverlay.InitialOpacity;
		this.createOpacityControl(this.map.googleMap, this.opacity);
	};

	/*
	 * Inherit from TileOverlay.
	 */
	maphub.AlphaOverlay.prototype = new maphub.TileOverlay();
	maphub.AlphaOverlay.constructor = maphub.AlphaOverlay;

	/*
	 * Set up some static "constants".
	 */
	maphub.AlphaOverlay.SliderWidth = 57;
	maphub.AlphaOverlay.InitialOpacity = 50;
	maphub.AlphaOverlay.SliderImageURL = '/images/opacity-slider.png';
	
	maphub.AlphaOverlay.prototype.getTile = function(point, zoomLevel, container) {
		console.log("maphub.AlphaOverlay.prototype.getTile");
		/*
		 * Call super().
		 */
		var tile = maphub.TileOverlay.prototype.getTile.apply(this, [point, zoomLevel, container]);
		return tile;
	}
	
	maphub.AlphaOverlay.prototype.createOpacityControl = function(map, opacity) {
		// Create main div to hold the control.
		var opacityDiv = document.createElement('DIV');
		opacityDiv.setAttribute("style", "margin:5px;overflow-x:hidden;overflow-y:hidden;background:url(" + maphub.AlphaOverlay.SliderImageURL + ") no-repeat;width:71px;height:21px;cursor:pointer;");

		// Create knob
		var opacityKnobDiv = document.createElement('DIV');
		opacityKnobDiv.setAttribute("style", "padding:0;margin:0;overflow-x:hidden;overflow-y:hidden;background:url(" + maphub.AlphaOverlay.SliderImageURL + ") no-repeat -71px 0;width:14px;height:21px;");
		opacityDiv.appendChild(opacityKnobDiv);

		var opacityCtrlKnob = new ExtDraggableObject(opacityKnobDiv, {
			restrictY: true,
			container: opacityDiv
		});

		google.maps.event.addListener(opacityCtrlKnob, "dragend", function () {
			this.setOpacity(opacityCtrlKnob.valueX());
		});

		google.maps.event.addDomListener(opacityDiv, "click", function (e) {
			var left = this.findPosLeft(this);
			var x = e.pageX - left - 5; // - 5 as we're using a margin of 5px on the div
			opacityCtrlKnob.setValueX(x);
			this.setOpacity(x);
		});

		this.map.googleMap.controls[google.maps.ControlPosition.TOP_RIGHT].push(opacityDiv);

		// Set initial value
		var initialValue = maphub.AlphaOverlay.SliderWidth / (100 / this.opacity);
		opacityCtrlKnob.setValueX(initialValue);
		this.setOpacity(initialValue);
	}

	maphub.AlphaOverlay.prototype.setOpacity = function(pixelX) {
		// Range = 0 to maphub.AlphaOverlay.SliderWidth
		var value = (100 / maphub.AlphaOverlay.SliderWidth) * pixelX;
		if (value < 0) value = 0;
		if (value == 0) {
			if (overlay.visible == true) {
				overlay.hide();
			}
		} else {
			this.setOpacity(value);
			if (overlay.visible == false) {
				overlay.show();
			}
		}
	}

	maphub.AlphaOverlay.prototype.findPosLeft = function(obj) {
		var curleft = 0;
		if (obj.offsetParent) {
			do {
				curleft += obj.offsetLeft;
			} while (obj = obj.offsetParent);
			return curleft;
		}
		return undefined;
	}
	
	maphub.AlphaOverlay.prototype.toString = function() {
		return 'AlphaOverlay<map='+this.map+', opacity='+this.opacity+', tileSize='+this.tileSize+'>';
	}
});
