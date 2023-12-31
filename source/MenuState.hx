package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxState;
/**
    autore@ RonyxDumb
    20/12/2023

    openAI ti devo un favore :")
**/
class MenuState extends FlxState 
{
    // estetica menu
    var cubeGrid:FlxBackdrop;

    // menu selezionabile
    private static var MENU_ITEMS:Array<FlxText>;
    private static var SELECTED_COLOR:Int = FlxColor.RED;
    private static var UNSELECTED_COLOR:Int = FlxColor.WHITE;
    private var selectedOption:Int = 0;
    private static var menuItem:Array<FlxText>;

    // roba della transizion
   // var transIn:FlxTransitionableState;
   // var transOut:FlxTransitionableState;

    override function create()
    {
        super.create();

        // roba della transizione
       // transIn = FlxTransitionableState.defaultTransIn;
       // transOut = FlxTransitionableState.defaultTransOut;

        // cubeGrid
        var cubeGrid = new FlxBackdrop(FlxGridOverlay.createGrid(100, 50, 100, 50, true, FlxColor.WHITE, FlxColor.BLACK));
        cubeGrid.velocity.set(20, 20);
        cubeGrid.alpha = 0.5;

        // menu selezionabile
        MENU_ITEMS = new Array<FlxText>();
        MENU_ITEMS.push(new FlxText(0, 0, 0, "Storia", 30).setFormat(Paths.font("vcr.ttf"), 30, UNSELECTED_COLOR, CENTER));
        MENU_ITEMS.push(new FlxText(0, 0, 0, "Crediti", 30).setFormat(Paths.font("vcr.ttf"), 30, UNSELECTED_COLOR, CENTER));
        MENU_ITEMS.push(new FlxText(0, 0, 0, "Impostazioni", 30).setFormat(Paths.font("vcr.ttf"), 30, UNSELECTED_COLOR, CENTER));

        for (menuItem in MENU_ITEMS)
            {
                add(menuItem);
            }

        aggiornaElementoSelezionato();
    }

    override function update(elpased:Float)
    {
        super.update(elpased);

        // controlla l'user cosa seleziona
        if (FlxG.keys.justPressed.DOWN) {
            selectedOption = (selectedOption +1) % MENU_ITEMS.length;
        } else if (FlxG.keys.justPressed.UP) {
            selectedOption = (selectedOption -1) % MENU_ITEMS.length;
        }

        // aggiornamento continuo...
        aggiornaElementoSelezionato();

        // se clicchi indietro
        if (FlxG.keys.justPressed.BACKSPACE)
        {
            Main.switchState(new TitleState());
        }

        // ora invece controlla se l'user clicca INVIO
        // durante la scelta di uno di questi
        if (FlxG.keys.justPressed.ENTER) {
            switch (selectedOption)
            {
                case 0: // modalità storia
                        trace("hai cliccato storia");
                case 1: // crediti
                        trace("hai cliccato crediti");
                case 2: // impostazioni
                        trace("hai cliccato le impostazioni");
            }
        }
    }

    // funzione che aggiorna l'elemento selezionato, etc...
    function aggiornaElementoSelezionato():Void
    {
        for (i in 0...MENU_ITEMS.length) ({
            var menuItems:FlxText = MENU_ITEMS[i];

            if (i == selectedOption) {
                menuItems.color = SELECTED_COLOR; // quando selezioni un elemento, il colore sarà rosso
            } else {
                menuItems.color = UNSELECTED_COLOR; // caso contrario, in caso di non selezionamento, sarà bianco
            }
            
        });
    }
}
