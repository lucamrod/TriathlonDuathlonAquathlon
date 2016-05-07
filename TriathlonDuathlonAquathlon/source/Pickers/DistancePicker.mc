using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

const MINUTE_FORMAT = "%02d";

class DistancePicker extends Ui.Picker {

    function initialize() {

        var title = new Ui.Text({:text=>Rez.Strings.distancePickerTitle, :locX=>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var factories;
        var settings = Sys.getDeviceSettings();

        factories = new [4];
        factories[0] = new NumberFactory(0, 9, 1);
        factories[1] = new Ui.Text({:text=>Rez.Strings.distanceSeparator, :font=>Gfx.FONT_MEDIUM, :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        factories[2] = new NumberFactory(0, 95, 5, {:format=>MINUTE_FORMAT});
        if( settings.paceUnits == Sys.UNIT_METRIC ){
        	factories[3] = new Ui.Text({:text=>Rez.Strings.kilometers, :font=>Gfx.FONT_MEDIUM, :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        }
        else{
        	factories[3] = new Ui.Text({:text=>Rez.Strings.miles, :font=>Gfx.FONT_MEDIUM, :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        }

		var defaults = splitStoredDistance();
		if(defaults != null) {
            defaults[0] = factories[0].getIndex(defaults[0].toNumber());
            defaults[2] = factories[2].getIndex(defaults[2].toNumber());
        }
        

        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
    
    function splitStoredDistance(){
    	var storedValue = App.getApp().getProperty("AutolapDistance").toString();
    	var defaults = null;
    	var separatorIndex = 0;
    	
    	if(storedValue != null){
    		defaults = new [4];
    		defaults[1] = null;
    		defaults[3] = null;
    		
    		separatorIndex = storedValue.find(Ui.loadResource(Rez.Strings.distanceSeparator));
    		if(separatorIndex != null){
    			defaults[0] = storedValue.substring(0, separatorIndex);
    			defaults[2] = storedValue.substring(separatorIndex + 1, separatorIndex + 3);
    		}
    		else{
    			defaults = null;
    		}
    	}
    	return defaults;
    }

}

class DistancePickerDelegate extends Ui.PickerDelegate {
    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        var distance = values[0] + Ui.loadResource(Rez.Strings.distanceSeparator) + values[2].format(MINUTE_FORMAT);
        
        App.getApp().setProperty("AutolapDistance", distance.toFloat());

        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
