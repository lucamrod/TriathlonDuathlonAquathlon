using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Pos;
using Toybox.ActivityRecording as Rec;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Timer as Timer;


class Discipline {

	static var stageNames = [
		"Swim", 
		"Trans 1", 
		"Cycle", 
		"Trans 2", 
		"Run" ];
	static var stageSports = [ 
		Rec.SPORT_SWIMMING, 
		Rec.SPORT_TRANSITION, 
		Rec.SPORT_CYCLING, 
		Rec.SPORT_TRANSITION, 
		Rec.SPORT_RUNNING ];
	static var stageSubSports = [ 
		Rec.SUB_SPORT_LAP_SWIMMING, 
		Rec.SUB_SPORT_GENERIC, 
		Rec.SUB_SPORT_ROAD, 
		Rec.SUB_SPORT_GENERIC, 
		Rec.SUB_SPORT_STREET ];
	static var stageIcons = [ 
		Rez.Drawables.SwimIcon,
		Rez.Drawables.TransIcon,
		Rez.Drawables.CycleIcon,
		Rez.Drawables.TransIcon,
		Rez.Drawables.RunIcon ];
		
	var startTime = 0;
	var endTime = 0;
	var disciplineSession;
	
	var currentStage;
	var currentIcon;

	function initaliseDiscipline(stage) {
		currentStage = stage;
		currentIcon = Ui.loadResource(stageIcons[stage]);
	}
	
	function onBegin() {
		var logtxt = Lang.format("Starting $1$ ($2$ :: $3$)", [stageNames[currentStage], stageSports[currentStage], stageSubSports[currentStage]]);
		Sys.println(logtxt);
		startTime = Sys.getTimer();
		if( TriData.currentDiscipline == 0 || TriData.currentDiscipline == 2 || TriData.currentDiscipline == 4 ){
			disciplineSession = Rec.createSession( { :name=>stageNames[currentStage], :sport=>stageSports[currentStage], :subsport=>stageSubSports[currentStage] } );
    		if( disciplineSession != null )
    		{
    			var starttrue = false;
    			do{
    			starttrue = disciplineSession.start();
    			}
    			while(starttrue == false);
    		}
    	}
	}
	
	function onEnd() {
		endTime = Sys.getTimer();
		if( TriData.currentDiscipline == 0 || TriData.currentDiscipline == 2 || TriData.currentDiscipline == 4 ){
    		if( disciplineSession != null && disciplineSession.isRecording() )
    		{
    			var stoptrue = false;
    			var savetrue = false;	
				do{
				stoptrue = disciplineSession.stop();
				}
				while(stoptrue == false); 
			
				do {
    			savetrue = disciplineSession.save();
				}
				while( savetrue == false );
			
			
				disciplineSession = null;
				Ui.requestUpdate();
    		}
    	}
		disciplineSession = null;
	}
	
	function addRunLap(){
		if( disciplineSession != null && disciplineSession.isRecording() ){
			var addedlap = false;
			disciplineSession.addLap();
			//do {
    		//	addedlap = disciplineSession.addLap();
			//	}
			//	while( addedlap == false );
		}
		return true;
	}
	
	function onTick() {
	}

	function getStageName() {
		return stageNames[currentStage];
	}
}
