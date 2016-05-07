using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;



class FinishViewInputDelegate extends Ui.InputDelegate {
	function onKey(evt) {
	
		var keynum = Lang.format("F $1$", [evt.getKey()]);
		Sys.println(keynum);
		
		
	
	}
}

class FinishView extends Ui.View {

    //! Load your resources here
    function onLayout(dc) {
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();

		var elapsedTime = TriData.disciplines[4].endTime - TriData.disciplines[0].startTime; //
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(40, dc.getFontHeight( Gfx.FONT_LARGE )-dc.getFontHeight( Gfx.FONT_MEDIUM )+12, Gfx.FONT_MEDIUM, "Total:", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(dc.getWidth() - 40, 12, Gfx.FONT_LARGE, Functions.msToTime(elapsedTime), Gfx.TEXT_JUSTIFY_RIGHT);
		
		dc.drawLine( 0, dc.getFontHeight( Gfx.FONT_LARGE )+12, dc.getWidth(), dc.getFontHeight( Gfx.FONT_LARGE )+12 );
		
		drawDataFields(dc);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function drawDataFields(dc) {
		var y = dc.getFontHeight( Gfx.FONT_LARGE ) + 14;
		
		// Discipline Time
		var elapsedTime = TriData.disciplines[0].endTime - TriData.disciplines[0].startTime;
		y = drawDataField( dc, TriData.disciplines[0].getStageName(), Functions.msToTime(elapsedTime), y , Gfx.COLOR_GREEN );
		elapsedTime = TriData.disciplines[1].endTime - TriData.disciplines[1].startTime;
		y = drawDataField( dc, TriData.disciplines[1].getStageName(), Functions.msToTime(elapsedTime), y , Gfx.COLOR_DK_GRAY );
		elapsedTime = TriData.disciplines[2].endTime - TriData.disciplines[2].startTime;
		y = drawDataField( dc, TriData.disciplines[2].getStageName(), Functions.msToTime(elapsedTime), y , Gfx.COLOR_GREEN );
		elapsedTime = TriData.disciplines[3].endTime - TriData.disciplines[3].startTime;
		y = drawDataField( dc, TriData.disciplines[3].getStageName(), Functions.msToTime(elapsedTime), y , Gfx.COLOR_DK_GRAY );
		elapsedTime = TriData.disciplines[4].endTime - TriData.disciplines[4].startTime;
		y = drawDataField( dc, TriData.disciplines[4].getStageName(), Functions.msToTime(elapsedTime), y , Gfx.COLOR_GREEN );

	}
	
	function drawDataField(dc, label, value, y, color) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawText(35, y, Gfx.FONT_MEDIUM, label, Gfx.TEXT_JUSTIFY_LEFT);
		dc.setColor(color, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth() - 35, y, Gfx.FONT_MEDIUM, value, Gfx.TEXT_JUSTIFY_RIGHT);
		y += dc.getFontHeight( Gfx.FONT_MEDIUM );
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawLine( 0, y, dc.getWidth(), y );
		y++;
		return y;
	}
}