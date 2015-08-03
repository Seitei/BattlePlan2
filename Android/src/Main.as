package {
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import starling.core.Starling;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;
import starling.utils.SystemUtil;
import starling.utils.formatString;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#000000")]
public class Main extends Sprite
{

    private const _stageWidth:int  = 1024;
    private const _stageHeight:int = 768;
    private var _nativeBackground:Loader;
    private var _scaleFactor:int;

    private var _starlingInstance:Starling;

    public function Main()
    {

        var iOS:Boolean = SystemUtil.platform == "IOS";
        var stageSize:Rectangle  = new Rectangle(0, 0, _stageWidth, _stageHeight);
        var screenSize:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
        var viewPort:Rectangle = RectangleUtil.fit(stageSize, screenSize, ScaleMode.SHOW_ALL);
        var scaleFactor:int = viewPort.height < 1024 ? 1 : 2;

        Starling.multitouchEnabled = true; // useful on mobile devices
        Starling.handleLostContext = true; // recommended everywhere when using AssetManager

        _starlingInstance = new Starling(Root, stage, viewPort, null, "auto", "auto");
        _starlingInstance.stage.stageWidth    = _stageWidth;  // <- same size on all devices!
        _starlingInstance.stage.stageHeight   = _stageHeight; // <- same size on all devices!
        _starlingInstance.addEventListener(starling.events.Event.ROOT_CREATED, function():void
        {
            loadAssets(scaleFactor, start);
        });

        _starlingInstance.start();
        initElements(scaleFactor);
        _scaleFactor = scaleFactor;


    }

    private function loadAssets(scaleFactor:int, onComplete:Function):void
    {

        var appDir:File = File.applicationDirectory;
        var assets:AssetManager = new AssetManager(scaleFactor);

        assets.verbose = Capabilities.isDebugger;
        assets.enqueue(

                appDir.resolvePath(formatString("assets/{0}x/common", scaleFactor))

        );

        assets.loadQueue(function(ratio:Number):void
        {

            if (ratio == 1) onComplete(assets);

        });
    }


    private function initElements(scaleFactor:int):void
    {
        // Add background image. By using "loadBytes", we can avoid any flickering.

        var bgPath:String = formatString("assets/{0}x/common/splash.jpg", scaleFactor);
        var bgFile:File = File.applicationDirectory.resolvePath(bgPath);
        var bytes:ByteArray = new ByteArray();
        var stream:FileStream = new FileStream();
        stream.open(bgFile, FileMode.READ);
        stream.readBytes(bytes, 0, stream.bytesAvailable);
        stream.close();

        _nativeBackground = new Loader();
        _nativeBackground.loadBytes(bytes);
        _nativeBackground.scaleX = 1.0 / scaleFactor;
        _nativeBackground.scaleY = 1.0 / scaleFactor;
        _starlingInstance.nativeOverlay.addChild(_nativeBackground);

        _nativeBackground.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
        function(e:Object):void
        {
            (_nativeBackground.content as Bitmap).smoothing = true;
        });

    }

    private function start(assets:AssetManager):void
    {
        var root:Root = _starlingInstance.root as Root;
        root.start(assets);
        setTimeout(removeElements, 150); // delay to make 100% sure there's no flickering.
    }


    private function removeElements():void
    {
        if (_nativeBackground)
        {
            _starlingInstance.nativeOverlay.removeChild(_nativeBackground);
            _nativeBackground = null;
        }

    }

























}
}