using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class MainMenuInputDelegate extends Ui.MenuInputDelegate {
	
	function onMenuItem(item) {
        if ( item == :item_1 ) {
            Ui.pushView( new Rez.Menus.ModeMenu(), new ModeMenuInputDelegate(), Ui.SLIDE_LEFT );
			Ui.requestUpdate();
        } else if ( item == :item_2 )  {
            Ui.pushView( new Rez.Menus.RunSettings(), new RunSettingsInputDelegate(), Ui.SLIDE_LEFT );
            Ui.requestUpdate();
        }
        else{
        	Ui.pushView( new Rez.Menus.ChangeMode(), new ChangeModeInputDelegate(), Ui.SLIDE_LEFT );
            Ui.requestUpdate();
        }
    }

}

class ModeMenuInputDelegate extends Ui.MenuInputDelegate {

	function onMenuItem(item) {
        if ( item == :item_1 ) {
			App.getApp().setProperty( "TriathlonMode", 0 );
			Ui.requestUpdate();   
        } 
        else if ( item == :item_2 ) {
            App.getApp().setProperty( "TriathlonMode", 1 );
			Ui.requestUpdate();
        }
        else{
        	App.getApp().setProperty( "TriathlonMode", 2 );
			Ui.requestUpdate();
        }
    }

}

class RunSettingsInputDelegate extends Ui.MenuInputDelegate {

	function onMenuItem(item) {
        if ( item == :item_1 ) {
			Ui.pushView( new Rez.Menus.PaceField(), new PaceFieldMenuInputDelegate(), Ui.SLIDE_LEFT );
			Ui.requestUpdate();   
        } 
        else if (item == :item_2 ) {
			Ui.pushView( new Rez.Menus.AutoLap(), new AutoLapMenuInputDelegate(), Ui.SLIDE_LEFT );
			Ui.requestUpdate();
        }
        else{
        	Ui.pushView(new DistancePicker(), new DistancePickerDelegate(), Ui.SLIDE_LEFT);
        }
    }

}

class ChangeModeInputDelegate extends Ui.MenuInputDelegate {
	
	function onMenuItem(item) {
        if ( item == :item_1 ) {
			App.getApp().setProperty( "TwoTimesPressLap", false );
			Ui.requestUpdate();   
        } 
        else{
        	App.getApp().setProperty( "TwoTimesPressLap", true );
			Ui.requestUpdate();
        }
    }
}

class AutoLapMenuInputDelegate extends Ui.MenuInputDelegate {

	function onMenuItem(item) {
        if ( item == :item_1 ) {
			App.getApp().setProperty( "AutolapMode", true );
			Ui.requestUpdate();   
        } 
        else{
        	App.getApp().setProperty( "AutolapMode", false );
			Ui.requestUpdate();
        }
    }

}

class PaceFieldMenuInputDelegate extends Ui.MenuInputDelegate {

	function onMenuItem(item) {
        if ( item == :item_1 ) {
			App.getApp().setProperty( "PaceField", 0 );
			Ui.requestUpdate();   
        } 
        else if ( item == :item_2 ) {
            App.getApp().setProperty( "PaceField", 1 );
			Ui.requestUpdate();
        }
        else{
        	App.getApp().setProperty( "PaceField", 2 );
			Ui.requestUpdate();
        }
    }

}


