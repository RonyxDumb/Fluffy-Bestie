package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import openfl.Assets;
import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import openfl.display.FPS;
import openfl.Lib;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
/**
	autore@ RonyxDumb
	16/12/2023
**/
class Main extends Sprite
{
	// IL GIOCO
	var game:FlxGame; // il gioco a sè
	var gameWidht:Int = 1280; // grandezza schermo
	var gameHeight:Int = 720; // grandezza schermo
	var FPS:FPS; // fps
	var skipSplash:Bool = true; // salta il logo di haxeflixel all'avvio
	var initialState:Class<FlxState> = TitleState; // con cosa inizia il gioco
	var framerate:Int = 120; // a quanti frame dovrebbe girare il gioco
	public static var focusMusicTween:FlxTween; // musica che si dissolve all'uscita dalla finestra
	private var camera:FlxCamera; // la camera del gioco

	public function new()
	{
		super();

		// Imposta il gioco
		setupGame();
	}

	// elabora "Main"
	public function main():Void
	{
		Lib.current.addChild(new Main());
	}

	// quando compili il gioco, genera un file chiamato
	// "BUILDTIME" in cui verrà scritto:
	// - Data
	// - Directory
	static function infoTerminal()
	{
		var currentData = Date.now().toString(); // ottieni la data attuale
		// var currentDirectory = Sys.getCwd(); // ottieni la directory 

		// scrivi cià all'esecuzione del gioco
		trace("Data: " + currentData /*+ "\nDirectory: " + currentDirectory*/);
	}

	// imposta alcune cose del gioco
	private function setupGame():Void
	{
		// il gioco
		game = new FlxGame(gameWidht, gameHeight, initialState, framerate, framerate, true, false);
		addChild(game);

		// grandezza schermo
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var stageWidht:Int = Lib.current.stage.stageWidth;

		// caratteristiche a schermo
		FPS = new FPS(10, 10, FlxColor.WHITE);
		addChild(FPS);

		// carica tutti i suoni all'avvio
		FlxG.sound.cacheAll(); // usa un più di memoria da parte del dispositivo

		/////////////////////// OTTIMIZZAZIONE ////////////////////
		// PS credo che consumi più memoria, ma dovrebbe reggere

		// FALSO
		// autopausa quando si esce dall'app?
		FlxG.autoPause = false;

		// CARICA E PULISCI
		
		// musica
		Assets.cache.clear("music");
		Assets.cache.clear("assets/music");

		// immagini
		Assets.cache.clear("images");
		Assets.cache.clear("assets/images");

		// suoni
		// i suoni vengono già caricati con la funzione:
		// "FlxG.sound.cacheAll();"

		///////////////////////////////////////////////////////////

		// registra le funzioni
		// inUsctaFinestra
		// inEntrataFinestra
		Application.current.window.onFocusIn.add(inEntrataFinestra);
		Application.current.window.onFocusOut.add(inUscitaFinestra);

		// registra la funzione main che viene utilizzata
		// per scrivere alcune informazioni nel terminale 
		#if debug
		infoTerminal();
		#end
	}

	// transizione per quando esci da uno State
	public static function switchState(target:FlxState)
	{	
		FlxG.switchState(target);
	}

	// funzione che riavvia l'app
	public static function riavvioAPP()
	{
		FlxG.resetGame();
	}

    /* NON NECESSARIA IN QUANTO NON PUOI USARLA MENTRE ENTRI IN UNO STATE
	// transizione per quando entri in uno State
	function switchStateFadeIn(target:FlxState)
	{
		new DiamondTransSubState(0.5, true, null);
	}
	*/

	var preVolum:Float = 1;
	var newVolum:Float = 1;
	public static var focused:Bool = true;

	// funzione per quando esci dalla finestra
	function inUscitaFinestra()
	{
		focused = false;

		// abbassa il volume quando si esce dalla finestra
		if (Type.getClass(FlxG.state) !=PlayState) // escluso il PlayState
		{
			preVolum = FlxG.sound.volume;
			if (preVolum > 0.3)
			{
				newVolum = 0.3;
			}
			else 
			{
				if (preVolum > 0.1)
				{
					newVolum = 0.1;
				}
				else
				{
					newVolum = 0;
				}
			}

			trace("Gioco focused");

			if (focusMusicTween != null)
				focusMusicTween.cancel();
			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: newVolum}, 0.5);

			// per risparmiare energia, all'uscita dalla finestra
			// riduciamo il framerate da 120 a 60
			FlxG.drawFramerate = 60;
		}
	}

	function inEntrataFinestra()
	{
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			focused = true;
		});

		// ritorna al volume di prima al ritorno nella finestra
		if (Type.getClass(FlxG.state) !=PlayState)
		{
			trace("Gioco focused");

			// ritorna al volume predefinitiv al ritorno
			if (focusMusicTween !=null)
				focusMusicTween.cancel();

			focusMusicTween = FlxTween.tween(FlxG.sound, {volume: preVolum}, 0.5);

			// ritorna il drawFramerate come prima
			FlxG.drawFramerate = 120;
		}
	}
}