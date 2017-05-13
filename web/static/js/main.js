
import Home from "./home"
import Game from "./game"

var elixirquest = new Phaser.Game(980, 500,
    (navigator.userAgent.toLowerCase().indexOf('firefox') > -1 ? Phaser.CANVAS : Phaser.AUTO),
    document.getElementById('game'),null,true,false);

elixirquest.state.add('Home',Home);
elixirquest.state.add('Game',Game);
elixirquest.state.start('Home', true, false, elixirquest);

/*
= Final TODO list:
* Quick: readme about main functions?
* Put on Github
* Make blog (add links to it in github readme)
* About, Share, Source, Credits (indep from Phaser), License, ...
 ->Give credit for external tools (phaser-input etc.)
* Setup game analytics (http://www.gameanalytics.com/) and google analytics
*/
