using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Attention as Att;

var testString = "Exit?";

class CDS extends Ui.ConfirmationDelegate {
    function onResponse(value) {
        if( value == 0 ) {
            Ui.switchToView(new TriathlonView(), new TriathlonViewInputDelegate(), Ui.SLIDE_UP);
            Ui.requestUpdate();
            return true;
        }
        else {
            Ui.popView( Ui.SLIDE_DOWN );
            return true;
        }
        //return false;
    }
}

class TriathlonViewInputDelegate extends Ui.InputDelegate {
	
	var settings = Sys.getDeviceSettings();

	function onKey(evt) {
	
		var keynum = Lang.format("T $1$", [evt.getKey()]);
		Sys.println(keynum);
		
		var gpsinfos = Pos.getInfo();
		var gpsIsOkay = ( gpsinfos.accuracy == Pos.QUALITY_GOOD || gpsinfos.accuracy == Pos.QUALITY_USABLE );
		
		if( (evt.getKey() == Ui.KEY_ENTER)) { 
			var recview = new RecordingView();
			var inpdelegate = new RecordingViewInputDelegate();
			
			TriData.configureDisciplines( App.getApp().getProperty( "TriathlonMode" ) );
			TriData.nextDiscipline();
			
			Ui.switchToView( recview, inpdelegate, Ui.SLIDE_UP );
			if (settings.vibrateOn == true){
				Att.vibrate( vibrateData );
			}
			if (settings.tonesOn == true){
				Att.playTone(Att.TONE_START);
			}
			Ui.requestUpdate();
			return true;
		}

		if( evt.getKey() == Ui.KEY_MENU ) {
			var MainMenu= new Rez.Menus.MainMenu();
			Ui.pushView( MainMenu, new MainMenuInputDelegate(), Ui.SLIDE_LEFT );
			Ui.requestUpdate();
			return true;
		}
		
		var cdS;
		if( evt.getKey() == Ui.KEY_ESC ) {
			cdS = new Ui.Confirmation( testString );
        	Ui.pushView( cdS, new CDS(), Ui.SLIDE_IMMEDIATE );
        	return true;
		}
		return false;
	}
}

class TriathlonView extends Ui.View {

	var string_type = "Triathlon";
	var string_autolap = "Auto Lap: On";
	var string_distance = "Lap Dist. = 1 km";
	var string_changeMode = "1 press to change discipline";
	var settings = Sys.getDeviceSettings();

	var refreshtimer;
	var blinkOn = 0;
	
	
    function timercallback()
    {
    	blinkOn = 1 - blinkOn;
        Ui.requestUpdate();
    }

    //! Load your resources here
    function onLayout(dc) {
		refreshtimer = new Timer.Timer();
		refreshtimer.start( method(:timercallback), 1000, true );
		
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	drawPrepare(dc);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }


	function drawIntro(dc) {
		}
	
	function drawPrepare(dc) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		
		// Draw GPS Status
		var gpsinfo = Pos.getInfo();
		var gpsIsOkay = ( gpsinfo.accuracy == Pos.QUALITY_GOOD || gpsinfo.accuracy == Pos.QUALITY_USABLE );
		
		dc.setColor( Functions.getGPSQualityColour(gpsinfo), Gfx.COLOR_BLACK);
		dc.fillRectangle(0, dc.getHeight() -35, dc.getWidth(), 4);
		dc.fillRectangle(0, dc.getHeight() -9, dc.getWidth(), 4);

		// Draw the current Mode
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_BLACK);
		if( App.getApp().getProperty( "TriathlonMode" ) == 0 ){
			string_type="Triathlon";
		}
		else if ( App.getApp().getProperty( "TriathlonMode" ) == 1 ){
			string_type="Aquathlon";
		}
		else{
			string_type="Duathlon";
		}
		dc.drawText(dc.getWidth() / 2, (dc.getHeight() - dc.getFontHeight(Gfx.FONT_LARGE)) / 2-15, Gfx.FONT_LARGE, string_type, Gfx.TEXT_JUSTIFY_CENTER);
		
		// Draw the status of the autolap
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		if(App.getApp().getProperty( "AutolapMode" ) == true){
			string_autolap = "Run AutoLap: On";
		}
		else{
			string_autolap = "Run AutoLap: Off";
		}
		dc.drawText(dc.getWidth() / 2 - 20, 105, Gfx.FONT_SMALL, string_autolap,Gfx.TEXT_JUSTIFY_LEFT); 
		
		if(settings.paceUnits == Sys.UNIT_METRIC){
			string_distance = Lang.format("Lap Dist. = $1$ km", [App.getApp().getProperty( "AutolapDistance" ).format("%.02f")]);
		}
		else{
			string_distance = Lang.format("Lap Dist. = $1$ mi", [App.getApp().getProperty( "AutolapDistance" ).format("%.02f")]);
		}
		dc.drawText(dc.getWidth() / 2 - 20, 120, Gfx.FONT_SMALL, string_distance,Gfx.TEXT_JUSTIFY_LEFT);
		
		if(App.getApp().getProperty( "TwoTimesPressLap" ) == true){
			string_changeMode = "Change Disc. Mode: 2";
		}
		else{
			string_changeMode = "Change Disc. Mode: 1";
		}
		dc.drawText(dc.getWidth() / 2, 0, Gfx.FONT_XTINY, string_changeMode,Gfx.TEXT_JUSTIFY_CENTER);
		
		var segwidth = (dc.getWidth() - 8) / 4;
		var xfwidth = segwidth / 2;
		
		var curx = 0;
		
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		Functions.drawChevron(dc, curx, curx + segwidth, dc.getHeight() - 20, 20, true, false);
		curx += segwidth + 2;
		
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		Functions.drawChevron(dc, curx, curx + xfwidth, dc.getHeight() - 20, 20, false, false);
		curx += xfwidth + 2;

		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		Functions.drawChevron(dc, curx, curx + segwidth, dc.getHeight() - 20, 20, false, false);
		curx += segwidth + 2;

		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		Functions.drawChevron(dc, curx, curx + xfwidth, dc.getHeight() - 20, 20, false, false);
		curx += xfwidth + 2;

		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		Functions.drawChevron(dc, curx, dc.getWidth(), dc.getHeight() - 20, 20, false, true);

		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.drawText(dc.getWidth() - 25, 17, Gfx.FONT_MEDIUM, "START >", Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(8, 102, Gfx.FONT_MEDIUM, "< MENU", Gfx.TEXT_JUSTIFY_LEFT);
		
		if( !gpsIsOkay ) {
			// Draw "Wait for GPS"
			var boxh = (dc.getFontHeight(Gfx.FONT_MEDIUM) * 2) + 6;
			
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
			dc.fillRectangle(dc.getWidth() / 6, (dc.getHeight() / 2) - (boxh / 2)-18, (dc.getWidth() / 6) * 4, boxh);
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			dc.drawRectangle(dc.getWidth() / 6, (dc.getHeight() / 2) - (boxh / 2)-18, (dc.getWidth() / 6) * 4, boxh);

			if( blinkOn == 0 ) {
		        dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) - dc.getFontHeight(Gfx.FONT_MEDIUM)-18, Gfx.FONT_MEDIUM, "Please Wait", Gfx.TEXT_JUSTIFY_CENTER);
		        dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2)-18, Gfx.FONT_MEDIUM, "For GPS", Gfx.TEXT_JUSTIFY_CENTER);
	        }
	        
		}
	}

}