package
{
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;

/** The Root class is the topmost display object in your game. It loads all the assets
 *  and displays a progress bar while this is happening. Later, it is responsible for
 *  switching between game and menu. For this, it listens to "START_GAME" and "GAME_OVER"
 *  events fired by the Menu and Game classes. Keep this class rather lightweight: it
 *  controls the high level behaviour of your game. */

  public class Root extends Sprite
{
    private static var _assets:AssetManager;

    private var _activeScene:Sprite;

    public function Root()
    {
        // not more to do here -- Startup will call "start" immediately.

    }

    public static function getScaleFactor():int {

        return _assets.scaleFactor;

    }

    public function start(assets:AssetManager):void
    {
        // the asset manager is saved as a static variable; this allows us to easily access
        // all the assets from everywhere by simply calling "Root.assets"

        _assets = assets;
        var image:Image = new Image(assets.getTexture("splash"));
        addChild(image);
        showScene(GameApp);

    }

    private function showScene(screen:Class):void
    {
        if (_activeScene) _activeScene.removeFromParent(true);
        _activeScene = new screen({assets: _assets, scaleFactor: _assets.scaleFactor});
        addChild(_activeScene);
    }


}





























}