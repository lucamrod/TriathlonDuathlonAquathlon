using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Sensor as Sensor;

var LapTime = 0;
var elapsedLapTimeP = 0;
var elapsedLapDistanceP = 0.0;
var LapCounter = 0;
var lapPace = "";
var change = 0;

class RecordingViewInputDelegate extends Ui.InputDelegate {


	function onKey(evt) {
		if( evt.getKey() == Ui.KEY_ESC ) {
			if (App.getApp().getProperty( "TwoTimesPressLap" ) == true){
				change = change + 1;
				if (change == 2){
					change = 0;
					TriData.nextDiscipline();
					Ui.requestUpdate();
				}
			}
			else{
				TriData.nextDiscipline();
				Ui.requestUpdate();
			}
		}
		
		
		// Imply that we handle everything
		return true;
	}
	
	function onTap(evt) {
		// No tap events
		return true;
	}
	
	function onSwipe(evt) {
		// No tap events
		return true;
	}
	
	function onHold(evt) {
		// No tap events
		return true;
	}
	
	function onRelease(evt) {
		// No tap events
		return true;
	}


}

class RecordingView extends Ui.View {

	var recordingtimer;
	var i = 0;
	var string_HR;
	var lapInitDistance = 0.0;
	var lapInitTime = 0;
	
	
    function recordingtimercallback()
    {
        Ui.requestUpdate();
    }

    //! Load your resources here
    function onLayout(dc) {
		// Get the Heart Rate Sensor enabled
    	
    	
    	string_HR = "---bpm";
		
		recordingtimer = new Timer.Timer();
		recordingtimer.start( method(:recordingtimercallback), 100, false );
		
		
		
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		
		changeReset();
		Sensor.enableSensorEvents(method(:onSnsr));
		drawTitleBar(dc);
		drawGPS(dc);
		drawSegments(dc);
		drawDataFields(dc);
		
		
    }
    
    function onSnsr(sensor_info)
    {
        var HR = sensor_info.heartRate;
        var bucket;
        if( sensor_info.heartRate != null )
        {
            string_HR = HR.toString() + "bpm";

        }
        else
        {
            string_HR = "---bpm";
        }
        

    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
	///////////////////////////////////////////////////////////////////////////////////// Render functions
    function drawGPS(dc) {
		var gpsinfo = Pos.getInfo();
		var gpsIsOkay = ( gpsinfo.accuracy == Pos.QUALITY_GOOD || gpsinfo.accuracy == Pos.QUALITY_USABLE );
		
		dc.setColor( Functions.getGPSQualityColour(gpsinfo), Gfx.COLOR_BLACK);
		dc.fillRectangle(0, 30, dc.getWidth(), 2);
    }

	function drawSegments(dc) {
		var segwidth = (dc.getWidth() - 8) / 4;
		var xfwidth = segwidth / 2;
		
		var curx = 0;
		
		
		dc.setColor( getSegmentColour(0), Gfx.COLOR_BLACK );
		Functions.drawChevron(dc, curx, curx + segwidth, 38, 10, true, false);
		curx += segwidth + 2;
		
		dc.setColor( getSegmentColour(1), Gfx.COLOR_BLACK );
		Functions.drawChevron(dc, curx, curx + xfwidth, 38, 10, false, false);
		curx += xfwidth + 2;

		dc.setColor( getSegmentColour(2), Gfx.COLOR_BLACK );
		Functions.drawChevron(dc, curx, curx + segwidth, 38, 10, false, false);
		curx += segwidth + 2;

		dc.setColor( getSegmentColour(3), Gfx.COLOR_BLACK );
		Functions.drawChevron(dc, curx, curx + xfwidth, 38, 10, false, false);
		curx += xfwidth + 2;

		dc.setColor( getSegmentColour(4), Gfx.COLOR_BLACK );
		Functions.drawChevron(dc, curx, dc.getWidth(), 38, 10, false, true);
	}
	
	function getSegmentColour(segmentNumber) {
		if( TriData.currentDiscipline == segmentNumber ) {
			return Gfx.COLOR_ORANGE;
		} else if( TriData.currentDiscipline > segmentNumber ) {
			return Gfx.COLOR_DK_GREEN;
		}
		return Gfx.COLOR_LT_GRAY;
	}
	
	function drawTitleBar(dc) {
		var elapsedTime = Sys.getTimer() - TriData.disciplines[0].startTime;
		
		dc.drawBitmap( 35, 0, TriData.disciplines[TriData.currentDiscipline].currentIcon );
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(69, 0, Gfx.FONT_MEDIUM, "Total:", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(dc.getWidth() - 40, 0, Gfx.FONT_MEDIUM, Functions.msToTime(elapsedTime), Gfx.TEXT_JUSTIFY_RIGHT);
	}
	
	function drawDataFields(dc) {
		var y = 44;
		
		
		// Discipline Time
		var elapsedTime = Sys.getTimer() - TriData.disciplines[TriData.currentDiscipline].startTime;
		y = drawDataField( dc, "Discipline:", Functions.msToTime(elapsedTime), y );
		
		if( TriData.currentDiscipline == 1 || TriData.currentDiscipline == 3 ) {
			y = drawDataField( dc, null, "Transistion", y );
		} else {
			var cursession = Act.getActivityInfo();
			y = drawDataField( dc, "Distance:", Functions.convertDistance(cursession.elapsedDistance), y );
			if ( TriData.disciplines[TriData.currentDiscipline].currentStage == 0 ){ 
				y = drawDataField( dc, "Pace:", Functions.convertSpeedToSwim(cursession.currentSpeed), y );
			} 
			else if ( TriData.disciplines[TriData.currentDiscipline].currentStage == 2 ){
				y = drawDataField( dc, "Vel.:", Functions.convertSpeedToBike(cursession.currentSpeed), y );
			}
			else if ( TriData.disciplines[TriData.currentDiscipline].currentStage == 4 ){
				calculateLapPace();
				if(App.getApp().getProperty( "PaceField" ) == 0){
					y = drawDataField( dc, "Pace:", Functions.convertSpeedToPace(cursession.currentSpeed), y );
				}
				else if (App.getApp().getProperty( "PaceField" ) == 1){
					y = drawDataField( dc, "Avg. Pace:", Functions.convertSpeedToPace(cursession.averageSpeed), y );
				}
				else{
					y = drawDataField( dc, "Lap Pace:", lapPace, y );
				}
			}
		}
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawText(35, y + (dc.getFontHeight( Gfx.FONT_MEDIUM ) - dc.getFontHeight( Gfx.FONT_SMALL )) / 2, Gfx.FONT_MEDIUM, "HR:", Gfx.TEXT_JUSTIFY_LEFT);
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth() - 35, y, Gfx.FONT_LARGE, string_HR, Gfx.TEXT_JUSTIFY_RIGHT);
		y += dc.getFontHeight( Gfx.FONT_LARGE );
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawLine( 0, y, dc.getWidth(), y );
		

	}
	
	function drawDataField(dc, label, value, y) {
		var smalloffset = (dc.getFontHeight( Gfx.FONT_MEDIUM ) - dc.getFontHeight( Gfx.FONT_SMALL )) / 2;
		
		if( label == null ) {
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			dc.drawText(dc.getWidth() / 2, y, Gfx.FONT_LARGE, value, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
			dc.drawText(20, y + smalloffset, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_LEFT);
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			dc.drawText(dc.getWidth() - 20, y, Gfx.FONT_LARGE, value, Gfx.TEXT_JUSTIFY_RIGHT);
		}
		y += dc.getFontHeight( Gfx.FONT_LARGE );
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawLine( 0, y, dc.getWidth(), y );
		y++;
		return y;
	}
	
	
	function calculateLapPace(){
		var cursession = Act.getActivityInfo();
		var elapsedLapTime = 0; // (ms)  
		var elapsedLapDistance = 0.0; // (m)
		var lapVel = 0.0d;
		var elapsedTime = cursession.elapsedTime;
		var elapsedDistance = cursession.elapsedDistance;
		
		if (TriData.ChangedDiscipline == true){
			lapInitTime = 0;
			lapInitDistance = 0.0;
			LapCounter = 0;
			TriData.ChangedDiscipline = false;
		}else{
			if ( elapsedTime != null && elapsedTime > 0 && elapsedDistance != null  && elapsedDistance > 0){
				elapsedLapTime = cursession.elapsedTime - lapInitTime;
				elapsedLapDistance = cursession.elapsedDistance - lapInitDistance;
				if ( elapsedLapTime > 0 && elapsedLapDistance > 0 ){
					lapVel = elapsedLapDistance.toDouble()/(elapsedLapTime.toDouble()/1000);
				}
			}
			
			if (App.getApp().getProperty( "AutolapMode" ) == true){
				var autolapdistance = Functions.convertToMeters(App.getApp().getProperty( "AutolapDistance" ));
				if (elapsedLapDistance >= autolapdistance){
					TriData.nextLap();
					LapTime = elapsedLapTimeP + (autolapdistance - elapsedLapDistanceP)/(elapsedLapDistance - elapsedLapDistanceP)*(elapsedLapTime - elapsedLapTimeP);
					lapInitTime = lapInitTime + LapTime;
					lapInitDistance = lapInitDistance + autolapdistance;
					LapCounter = LapCounter + 1;
					Ui.pushView(new LapView(), new RecordingViewInputDelegate(), Ui.SLIDE_IMMEDIATE);
				}
				elapsedLapTimeP = elapsedLapTime;
				elapsedLapDistanceP = elapsedLapDistance;
			}
		}	
		lapPace = Functions.convertSpeedToPace(lapVel);
		return lapPace;
	}
	
	var resetChange = 0;
	
	function changeReset(){
		if (change == 1){
			resetChange = resetChange + 1;
			if (resetChange == 2){
				resetChange = 0;
				change = 0;
			}
		} 
	}
	
}

// View when a lap is completed
class LapView extends Ui.View {
	
	var laptimer;
	var counter = 0;
	
	function laptimercallback()
    {
        Ui.requestUpdate();
    }
	
	function onLayout(dc){
		laptimer = new Timer.Timer();
		laptimer.start( method(:laptimercallback), 1000, false );
	}
	
	function onUpdate(dc){
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth()/2, dc.getFontHeight(Gfx.FONT_LARGE), Gfx.FONT_LARGE, "Lap " + LapCounter, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM)/2, Gfx.FONT_NUMBER_HOT, Functions.msToTimeWithDecimals(LapTime.toLong()), Gfx.TEXT_JUSTIFY_CENTER);
		if (counter < 50){
			counter = counter + 1;
		}
		else{
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		}
	}
	
}