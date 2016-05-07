using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Position as Pos;
using Toybox.ActivityRecording as Rec;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Attention as Att;

var vibrateData = [new Att.VibeProfile(  25, 100 ), new Att.VibeProfile(  50, 100 ), new Att.VibeProfile(  75, 100 ), new Att.VibeProfile( 100, 100 ), new Att.VibeProfile(  75, 100 ), new Att.VibeProfile(  50, 100 ), new Att.VibeProfile(  50, 100 ) ];
var vibrateData1 = [new Att.VibeProfile(  25, 200 ), new Att.VibeProfile(  50, 200 ), new Att.VibeProfile(  75, 200 ), new Att.VibeProfile( 100, 200 ), new Att.VibeProfile(  75, 200 ), new Att.VibeProfile(  50, 200 ), new Att.VibeProfile(  50, 200 ) ];

module TriData {

	var disciplines = [ new Discipline(), new Discipline(), new Discipline(), new Discipline(), new Discipline() ];
	var currentDiscipline = -1;
	var ChangedDiscipline = false;
	var settings = Sys.getDeviceSettings();
	

	///////////////////////////////////////////////////////////////////////////////////// External functions
	function configureDisciplines( triMode ) {

		// Normal Triathlon	
		if( triMode == 0 )
		{
			disciplines[0].initaliseDiscipline(0);
			disciplines[1].initaliseDiscipline(1);
			disciplines[2].initaliseDiscipline(2);
			disciplines[3].initaliseDiscipline(3);
			disciplines[4].initaliseDiscipline(4);
		}
		// Aquathlon
		if( triMode == 1 )
		{
			disciplines[0].initaliseDiscipline(4);
			disciplines[1].initaliseDiscipline(1);
			disciplines[2].initaliseDiscipline(0);
			disciplines[3].initaliseDiscipline(3);
			disciplines[4].initaliseDiscipline(4);
		}
		// Duathlon
		if( triMode == 2 )
		{
			disciplines[0].initaliseDiscipline(4);
			disciplines[1].initaliseDiscipline(1);
			disciplines[2].initaliseDiscipline(2);
			disciplines[3].initaliseDiscipline(3);
			disciplines[4].initaliseDiscipline(4);
		}
	}
	
	function nextDiscipline() {
		ChangedDiscipline = true;
		if( currentDiscipline >= 0 ) {
			if (currentDiscipline != 4){
				if (settings.vibrateOn == true){
					Att.vibrate( vibrateData );
				}
				if (settings.tonesOn == true){
					Att.playTone(Att.TONE_LAP);
				}
			}
			else{
				if (settings.vibrateOn == true){
					Att.vibrate( vibrateData1 );
				}
				if (settings.tonesOn == true){
					Att.playTone(Att.TONE_SUCCESS);
				}
			}
			disciplines[currentDiscipline].onEnd();
		}
		currentDiscipline++;
		if( currentDiscipline == 5 ) {
			currentDiscipline = 4;
			Ui.switchToView(new FinishView(), new FinishViewInputDelegate(), Ui.SLIDE_UP);
		} else {
			disciplines[currentDiscipline].onBegin();
			Ui.requestUpdate();
		}
	}
	
	function nextLap(){
		if (settings.vibrateOn == true){
			Att.vibrate( vibrateData );
		}
		if (settings.tonesOn == true){
			Att.playTone(Att.TONE_LAP);
		}
		disciplines[currentDiscipline].addRunLap();
	}
	
	
}
