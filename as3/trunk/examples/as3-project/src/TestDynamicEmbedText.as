package
{
	import com.sleepydesign.utils.ThaiUtil;
	
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	[SWF(backgroundColor = "#FFFFFF", frameRate = "30", width = "760", height = "600", embedAsCFF = "false")]
	public class TestDynamicEmbedText extends Sprite
	{
		[Embed(source = "C:\\Windows\\Fonts\\PSL029SP.TTF", mimeType = "application/x-font", fontName = "PSL DisplaySP", embedAsCFF = "false")]
		public var font_clazz:Class;

		public function TestDynamicEmbedText()
		{
			// init
			var tf:TextField;
			addChild(tf = new TextField);
			tf.autoSize = TextFieldAutoSize.LEFT;
			
			// embed
			tf.embedFonts = true;
			tf.styleSheet = new StyleSheet();
			tf.styleSheet.parseCSS("p {font-family:PSL DisplaySP;font-size:32px;color:#000000;}");

			// fix
			tf.htmlText = "<p>" + ThaiUtil.fix("ก่า") + "abc</p>";
			
			// test success embed
			tf.x = stage.stageWidth*.5;
			tf.y = stage.stageHeight*.5;
			tf.rotation = 45;
		}
	}
}