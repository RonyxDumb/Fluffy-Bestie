package;

import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxPointRangeBounds;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.addons.display.FlxSpriteAniRot;
import mobile.Vibradroid;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
/**
    autore@ RonyxDumb
    16/12/2023
**/
class TitleState extends FlxState 
{
    // estetica
    var cubeGrid:FlxBackdrop;
    var logo:FlxSprite;
    var pressTXT:FlxText;
    var bg:FlxSprite;
    var playBttn:FlxSprite;
    var playText:FlxSprite;

    // suoni 
    var clickSound:FlxSound; // inutilizzato, ma caricato con FlxG.music.sound.play();
    var titleMusic:FlxSound;

    // roba della transizione
    var diamond:FlxGraphic;

    override function create():Void
    {
        super.create();

        // (per favore prendetelo come un saluto)
        // all'avvio mostra un messaggino molto hihihiihihihih
        trace("a fess d mamt");

        // fade in della camera
        FlxG.camera.fade(FlxColor.BLACK, 0.7, true);

        // canzone di sottofondo iniziale
        // Instrumental (Royalty Free Music) - "REMEMBER" by @KaizanBlu 🇬🇧 (Living in 🇧🇬)
        var titleMusic = new FlxSound().loadEmbedded(Paths.music("Title"), true, false);
        titleMusic.play();

        // rendi visibile il mouse
        FlxG.mouse.visible = true;

        // grid di cubi marroni e bianchi come sfondo
        // grid con cuori marroni
        //var cubeGrid = new FlxBackdrop(FlxGridOverlay.createGrid(50, 50, 100, 100, true, FlxColor.WHITE, FlxColor.BROWN));
        var cubeGrid = new FlxBackdrop(Paths.image("Title/brown_heart_SMALLER"), XY, 0.0, 0.0);
        cubeGrid.velocity.set(20, 20);
        cubeGrid.alpha = 0.5;
		// FlxTween.tween(cubeGrid, {alpha: 0.5}, 0.5, {ease: FlxEase.quadOut});

        // bg per rimpiazzare cubeGrid
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);

        // logo del gioco (posizionato a sinistra, in alto)
        var logo = new FlxSprite();
        logo.loadGraphic(Paths.image("Title/FluffyBestie_Logo_SinistraAlto"), false, 0, 0, false);
        logo.antialiasing = true;
        //logo.scale.scale(0.5, 0.5);
        //logo.screenCenter(X);

        // Testo "Clicca per iniziare"
        var pressTXT = new FlxText(0, 0, 0, "CLICCA PER INIZIARE", 60, true);
        pressTXT.screenCenter(XY);
        pressTXT.setFormat(Paths.font("Bronx.otf"), 60, FlxColor.MAGENTA, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);

        // OOPS INDIE CROSS
        playBttn = new FlxSprite(660, 570);
		playBttn.frames = Paths.getSparrowAtlas('Title/Playbutton');
		playBttn.animation.addByPrefix('idle', 'Button instance 1', 24, true);
		playBttn.animation.play('idle', true);
		playBttn.setGraphicSize(Std.int(playBttn.width / 1.1));

		var playText:FlxSprite = new FlxSprite(playBttn.x + 50, playBttn.y + 10).loadGraphic(Paths.image('Title/PlayText'));
		playText.setGraphicSize(Std.int(playText.width / 1.1));

        // Transizione
        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

		    FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
                       
        // ordine in cui vengono aggiunte le cose
        // un pò come i layer no?
        add(bg);
        add(cubeGrid);
        add(logo);
        add(playBttn);
        add(playText);
        //add(pressTXT);
    }

    // cliccato invio corrisponde a:
    // - aver cliccato ENTER sulla tastiera
    // - aver ciccato il mouse
   // var cliccatoInvio:Bool = FlxG.keys.justPressed.ENTER;

   // dovrebbe funzionare da transizione
   var transitioning:Bool = false;

    override function update(elpased:Float)
    {
        super.update(elpased);

        // paragone al tasto ENTER
        var cliccatoInvio:Bool = FlxG.keys.justPressed.ENTER;

        // e da mobile,
        // - aver cliccato sullo schermo
        #if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				cliccatoInvio = true;
		}
        #end

        if (cliccatoInvio && !transitioning)
        {
            // flash(1, FlxColor.WHITE);
            FlxG.camera.flash(FlxColor.WHITE, 1);

            // controlla la data di oggi
            if (Date.now().getDate() == 5) // (evviva) [è quasi finita la settimana]
                trace("ci siamo quasi ragazzi oggi venerdiiiiiiii");

            // controlla l'ennesima data di oggi
            if (Date.now().getDate() == 1) // (ricomincia la tortuta settimanale)[intendo la scuola eh]
                trace("rip leggende oggi e lunedi");

            // se stai da mobile, vibra
            #if mobile
            Vibradroid.Vibrate(500);
            #end

            // riproduci suono click
            FlxG.sound.play(Paths.sound("click"));
            // clickSound.play();

            // fade della camera
            FlxG.camera.fade(FlxColor.BLACK, 1, false);

            // inizializza il timer
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                Main.switchState(new MenuState());
            });

            transitioning = true;
            
           // Main.switchState(new MenuState());
        }

        if (FlxG.keys.justPressed.R)
        {
            Main.riavvioAPP(); // riavvia l'app
        }
    }

    // funzione flash
    function flash(duration:Float, color:FlxColor)
    {
        FlxG.camera.stopFX(); 
        FlxG.camera.flash(color, duration);
    }
}