package com.sleepydesign.utils
{
	import flash.events.EventDispatcher;

	public class ThaiUtil
	{
		// input
		public static const DS_FAMILY:String = "ds";
		public static const PSL_AD_FAMILY:String = "psl_ad";
		public static const PSL_SP_FAMILY:String = "psl_sp";
		
		// output
		public static const ASCII_PS7:String = "ascii_ps7";
		public static const MULTIBYTE:String = "multibyte";
		public static const MULTIBYTE_CS:String = "multibyte_cs";
		
		//____________________________________________________________style

		private static var _thaiStyle:Object = {};

		//____________________________________________________________static

		private static var _TONE:String;
		private static var _VOWEL:String;
		private static var _BOTTOM_VOWEL:String;
		private static var _AUM:String;
		private static var _LONGTAIL:String;
		private static var _LOWTAIL:String;
		private static var _YOYING:String;
		private static var _YOYING_PS7:String;
		private static var _YOYING_NOTAIL:String;
		private static var _THOTHAN:String;
		private static var _THOTHAN_NOTAIL:String;

		//____________________________________________________________dynamic

		private static var _HIGHTONE:String;
		private static var _LOW_TONE:String;
		private static var _LOWERLEFT_TONE:String;
		private static var _LOWERLEFT_VOWEL:String;
		private static var _LOWBOTTOM_VOWEL:String;
		private static var _AUM_COMBO:String;
		private static var _ESCAPE_CHAR:String;

		//__________________________________________________________function

		private static function fixYoYing(target:String = ""):String
		{
			var resultString:String = "";
			if (_thaiStyle.isFixYoying || _thaiStyle.isFixYoyingTail)
			{
				for (var i:int = 0; i < target.length; i++)
				{
					//char by char
					var char:String = target.charAt(i);
					//skip some
					var isEscape:Boolean = (_ESCAPE_CHAR != null) && (_ESCAPE_CHAR.indexOf(char) > -1);
					//char code
					var charCode:Number = target.charCodeAt(i);
					//skip newline
					var isNewline:Boolean = (char == "\n");
					if (!isNewline && ((_YOYING + _THOTHAN).indexOf(char) > -1))
					{
						//next is bottomVowel?
						var isBeforeBottomVowel:Boolean = (_BOTTOM_VOWEL.indexOf(target.charAt(i + 1)) > -1) && (i + 1 < target.length);

						//_________________________________________________________________________ญ

						if (charCode == Number(_YOYING.charCodeAt(0)))
						{
							//isFixYoying
							if (_thaiStyle.isFixYoying)
							{
								char = _YOYING_PS7;
							}
							//isFixYoyingTail                
							if (_thaiStyle.isFixYoyingTail && isBeforeBottomVowel)
							{
								char = _YOYING_NOTAIL;
							}
						}

						//_________________________________________________________________________ฐ                

						if (charCode == Number(_THOTHAN.charCodeAt(0)))
						{
							//isFixYoyingTail
							if (_thaiStyle.isFixYoyingTail && isBeforeBottomVowel)
							{
								char = _THOTHAN_NOTAIL;
							}
						}
						resultString += char;
					}
					else
					{
						resultString += target.charAt(i);
					}
				}
			}
			else
			{
				return target;
			}
			//return
			return resultString;
		}

		public static function getEmbedString():String
		{
			var resultString:String = "";
			//normal
			for (var i:int = 20; i < 255; i++)
			{
				resultString += String.fromCharCode(i);
			}
			//fix
			resultString += _HIGHTONE + _LOW_TONE + _LOWERLEFT_TONE + _LOWERLEFT_VOWEL + _LOWBOTTOM_VOWEL + _AUM_COMBO + _YOYING_NOTAIL + _THOTHAN_NOTAIL;
			//return
			return resultString;
		}

		public static function asciiToUnicode(target:String = ""):String
		{
			//result                
			var resultString:String = "";
			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);
				//only thai and not fixed
				var charCode:Number = target.charCodeAt(i);
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if (!isNewline)
				{
					if ((charCode > 127) && (charCode < 3584) && (charCode < 0xF000))
					{
						//ascii -> unicode
						charCode = charCode + 3585 - 161;
					}
					resultString += String.fromCharCode(charCode);
				}
				else
				{
					resultString += char;
				}
			}
			//return
			return resultString;
		}

		public static function unicodeToAscii(target:String = ""):String
		{
			//result                
			var resultString:String = "";
			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);
				//only thai and not fixed
				var charCode:Number = target.charCodeAt(i);
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if (!isNewline)
				{
					if ((charCode > 3584) && (charCode < 0xF000))
					{
						//unicode ->ascii
						charCode = charCode - 3585 + 161;
					}
					if (charCode < 128)
					{
						resultString += char;
					}
					else
					{
						resultString += String.fromCharCode(charCode);
					}
				}
				else
				{
					resultString += char;
				}
			}
			//return
			return resultString;
		}

		private static function ps7Chr(target:String = ""):String
		{
			var resultString:String = "";
			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);
				//is that bottomVowel?
				var isLowBottomVowel:Boolean = (_LOWBOTTOM_VOWEL.indexOf(char) > -1);
				//skip some
				var isEscape:Boolean = (_ESCAPE_CHAR != null) && (_ESCAPE_CHAR.indexOf(char) > -1);
				//char code
				var charCode:Number = target.charCodeAt(i);
				//skip newline
				var isNewline:Boolean = (char == "\n");
				//only thai and not fixed
				if (!isNewline && !isLowBottomVowel && (charCode > 3584) && !isEscape)
				{
					//unicode ->ascii
					charCode = charCode - 3585 + 161;
					resultString += String.fromCharCode(charCode);
				}
				else
				{
					resultString += target.charAt(i);
				}
			}
			//return
			return resultString;
		}

		private static function csChr(target:String = ""):String
		{
			//result                
			var resultString:String = "";
			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);
				//only thai and not fixed
				var charCode:Number = target.charCodeAt(i);
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if (!isNewline)
				{
					if ((charCode > 3584) && (charCode < 0xF000))
					{
						//unicode ->ascii
						charCode = charCode - 3585 + 161;
					}
					if (charCode < 126)
					{
						resultString += char;
					}
					else
					{
						resultString += String.fromCharCode("0xF0" + charCode.toString(16));
					}
				}
				else
				{
					resultString += char;
				}
			}
			//return
			return resultString;
		}

		private static function removeCSChr(target:String = ""):String
		{
			//result                
			var resultString:String = "";
			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);
				//only thai and not fixed
				var charCode:Number = target.charCodeAt(i);
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if ((!isNewline) && (charCode > 128))
				{
					if ((charCode > 3584) && (charCode < 0xF000))
					{
						//unicode ->ascii
						charCode = -charCode + 3585 - 161;
					}
					//resultString += String.fromCharCode(charCode-0xF000+3585-161);          
					if (charCode < 126)
					{
						resultString += char;
					}
					else
					{
						resultString += String.fromCharCode(charCode - 0xF000 + 3585 - 161);
							//resultString += String.fromCharCode("0xF0"+charCode.toString(16));
					}
				}
				else
				{
					resultString += char;
				}
			}
			//return
			return resultString;
		}

		private static function removePS7Chr(target:String = ""):String
		{
			var resultString:String = "";
			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);
				//is that bottomVowel?
				var isLowBottomVowel:Boolean = (_LOWBOTTOM_VOWEL.indexOf(char) > -1);
				//skip some
				var isEscape:Boolean = (_ESCAPE_CHAR != null) && (_ESCAPE_CHAR.indexOf(char) > -1);
				//char code
				var charCode:Number = target.charCodeAt(i);
				//skip newline
				var isNewline:Boolean = (char == "\n");
				//only thai and not fixed
				if (!isNewline && !isLowBottomVowel && (charCode < 3584 - 21) && !isEscape)
				{
					//unicode ->ascii
					charCode = charCode + 3585 - 161;
					resultString += String.fromCharCode(charCode);
				}
				else
				{
					charCode = charCode - 3585 + 161;
					resultString += String.fromCharCode(charCode);
				}
			}
			//return
			return resultString;
		}

		public static function removeThaiStyle(target:String = "", inputThaiStyle:Object = null):String
		{
			if (inputThaiStyle == null)
			{
				inputThaiStyle = _thaiStyle
			}
			if (inputThaiStyle.fontFamily == null)
			{
				inputThaiStyle.fontFamily = PSL_AD_FAMILY;
			}
			//result                
			//setFontFamily
			setFontFamily(inputThaiStyle.fontFamily);
			//prepare asciiToUnicode
			if (inputThaiStyle.fontFamily == PSL_AD_FAMILY)
			{
				switch (inputThaiStyle.outputType)
				{
					case MULTIBYTE_CS:
						target = removeCSChr(target);
						_YOYING_PS7 = asciiToUnicode(_YOYING_PS7);
						_YOYING_NOTAIL = asciiToUnicode(_YOYING_NOTAIL);
						_THOTHAN_NOTAIL = asciiToUnicode(_THOTHAN_NOTAIL);
						//is that fixed? highTone,lowTone,lowerleftTone,lowerleftVowel,lowBottomVowel,aumCombo
						_HIGHTONE = asciiToUnicode(_HIGHTONE);
						_LOW_TONE = asciiToUnicode(_LOW_TONE);
						_LOWERLEFT_TONE = asciiToUnicode(_LOWERLEFT_TONE);
						_LOWERLEFT_VOWEL = asciiToUnicode(_LOWERLEFT_VOWEL);
						_LOWBOTTOM_VOWEL = asciiToUnicode(_LOWBOTTOM_VOWEL);
						//What's this [0],[1] for huh?,I almost fogot this 2 lines ;|
						//aumCombo[0] = asciiToUnicode(aumCombo[0]);
						//aumCombo[1] = asciiToUnicode(aumCombo[1]);
						_AUM_COMBO = asciiToUnicode(_AUM_COMBO);
						break;
					case ASCII_PS7:
						target = removePS7Chr(target);
						break;
				}
			}

			//result       
			var resultString:String = "";
			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);

				//is that fixed? yoying,thothan
				const yoyingPS7Pos:int = _YOYING_PS7.indexOf(char);
				const yoyingNoTailPos:int = _YOYING_NOTAIL.indexOf(char);
				const thothanNoTailPos:int = _THOTHAN_NOTAIL.indexOf(char);

				//is that fixed? highTone,lowTone,lowerleftTone,lowerleftVowel,lowBottomVowel,aumCombo
				const highTonePos:int = _HIGHTONE.indexOf(char);
				const lowTonePos:int = _LOW_TONE.indexOf(char);
				const lowerleftTonePos:int = _LOWERLEFT_TONE.indexOf(char);
				const lowerleftVowelPos:int = _LOWERLEFT_VOWEL.indexOf(char);
				const lowBottomVowelPos:int = _LOWBOTTOM_VOWEL.indexOf(char);
				const aumComboPos_0:int = _AUM_COMBO.charAt(0).indexOf(char);
				const aumComboPos_1:int = _AUM_COMBO.charAt(1).indexOf(char);

				//unfix : yoying,thothan
				if (yoyingPS7Pos > -1)
				{
					char = _YOYING.charAt(0);
				}
				if (yoyingNoTailPos > -1)
				{
					char = _YOYING.charAt(0);
				}
				if (thothanNoTailPos > -1)
				{
					char = _THOTHAN.charAt(0);
				}
				//unfix : tone,vowel,bottomVowel,aum                
				if (highTonePos > -1)
				{
					char = _TONE.charAt(highTonePos);
				}
				if (lowTonePos > -1)
				{
					char = _TONE.charAt(lowTonePos);
				}
				if (lowerleftTonePos > -1)
				{
					char = _TONE.charAt(lowerleftTonePos);
				}
				if (lowerleftVowelPos > -1)
				{
					char = _VOWEL.charAt(lowerleftVowelPos);
				}
				if (lowBottomVowelPos > -1)
				{
					char = _BOTTOM_VOWEL.charAt(lowBottomVowelPos);
				}
				if ((aumComboPos_0 > -1) && (aumComboPos_1 > -1) && ((aumComboPos_1 - aumComboPos_0) == 1))
				{
					char = _AUM.charAt(aumComboPos_0);
				}

				//grab                
				resultString += char;
			}
			if (inputThaiStyle.fontFamily != PSL_AD_FAMILY)
			{
				switch (inputThaiStyle.outputType)
				{
					case MULTIBYTE_CS:
						resultString = removeCSChr(resultString);
						break;
					case ASCII_PS7:
						//need fix
						resultString = removePS7Chr(resultString);
						break;
				}
			}
			//return     
			return resultString;
		}

		private static function fixFloat(target:String = ""):String
		{
			//result                
			var resultString:String = "";

			for (var i:int = 0; i < target.length; i++)
			{
				//char by char
				var char:String = target.charAt(i);

				//________________________________________________________________long tail		

				var isAfterLongTail:Boolean = (_LONGTAIL.indexOf(target.charAt(i - 1)) > -1) && (i >= 1);
				var isAfter2LongTail:Boolean = (_LONGTAIL.indexOf(target.charAt(i - 2)) > -1) && (i >= 2);

				//________________________________________________________________vowel		

				//is that  vowel?
				var vowelPos:int = _VOWEL.indexOf(char);
				//lowerleftVowel = สระ = ปิปีปึปืปั
				if (_thaiStyle.isFixTail && (vowelPos > -1) && isAfterLongTail)
				{
					char = _LOWERLEFT_VOWEL.charAt(vowelPos);
				}
				//is that bottomVowel?                
				var bottomVowelPos:int = _BOTTOM_VOWEL.indexOf(char);

				//________________________________________________________________tone		

				//is that tone?
				var tonePos:int = _TONE.indexOf(char);
				//skip newline
				var isNewline:Boolean = (char == "\n");
				//previous char is tone
				var isAfterTone:Boolean = (_TONE.indexOf(target.charAt(i - 1)) > -1) && (i >= 1);
				//tone found
				if (!isNewline && _thaiStyle.isFixFloat && (tonePos > -1))
				{
					//next is aum?
					var isBeforeAum:Boolean = (_AUM.indexOf(target.charAt(i + 1)) > -1) && (i + 1 < target.length);
					//prev is vowel?
					var isAfterVowel:Boolean = (_VOWEL.indexOf(target.charAt(i - 1)) > -1) && (i >= 1);
					//prev is lowvowel?
					var isAfterLowVowel:Boolean = (_LOWERLEFT_VOWEL.indexOf(target.charAt(i - 1)) > -1) && (i >= 1);
					if (!isAfterTone && !isBeforeAum && !isAfterVowel)
					{
						if (_thaiStyle.isFixTail && isAfterLongTail)
						{
							//avoid tail by move high tone to lower left 
							char = _LOWERLEFT_TONE.charAt(tonePos);
						}
						else
						{
							//just pull 'em down
							char = _LOW_TONE.charAt(tonePos);
						}
					}
					if (_thaiStyle.isFixTail)
					{
						const isAfterBottomVowel:Boolean = (_BOTTOM_VOWEL.indexOf(target.charAt(i - 1)) > -1) && (i >= 1);
						if (isAfter2LongTail && (isAfterVowel || isAfterLowVowel))
						{
							//highTone = ปิ่ปิ้ปิ๊ปิ๋
							char = _HIGHTONE.charAt(tonePos);
						}
						else if (isAfter2LongTail && isAfterBottomVowel)
						{
							//bottomVowel = ปุ่ปุ้ปุ๊ปุ๋
							char = _LOWERLEFT_TONE.charAt(tonePos);
						}
						else if (isAfterLongTail && isBeforeAum)
						{
							//highTone = ป่ำป้ำป๊ำป๋ำ      
							char = _HIGHTONE.charAt(tonePos);
						}
					}
				}

				//________________________________________________________________BOTTOM_VOWEL

				//is that bottomVowel?
				var isAfterLowTail:Boolean = (_LOWTAIL.indexOf(target.charAt(i - 1)) > -1) && (i >= 1);
				//ญุญูญฺ	
				if ((bottomVowelPos > -1) && isAfterLowTail && _thaiStyle.isFixLowTail)
				{
					char = _LOWBOTTOM_VOWEL.charAt(bottomVowelPos);
				}

				//________________________________________________________________aum

				//is that aum?
				var isAum:Boolean = (_AUM.indexOf(char) > -1);
				var isAfterLongTailTone:Boolean = isAfter2LongTail && isAfterTone;
				//ปำฟำฝำ,ป่ำป้ำป๊ำป๋ำ
				if (_thaiStyle.isFixAum && isAum && (isAfterLongTail || isAfterLongTailTone))
				{
					//break aum
					char = _AUM_COMBO;
				}
				//grab                
				resultString += char;
			}
			//return
			return resultString;
		}

		private static function replace(target:String, source_chr:String = "", replace_chr:String = ""):String
		{
			//return
			return target.split(source_chr).join(replace_chr);
		}

		public static function applyThaiStyle(target:String = ""):String
		{
			//result                
			var resultString:String = "";
			//fix Yoying
			target = fixYoYing(target);
			//fix Float
			target = fixFloat(target);
			//outputType : multibyte_cs, ascii_ps7, multibyte
			switch (_thaiStyle.outputType)
			{
				case MULTIBYTE_CS:
					resultString = csChr(target);
					break;
				case ASCII_PS7:
					resultString = ps7Chr(target);
					break;
				default:
					resultString = target;
					break;
			}
			//fix newline (0x0D0A->0x0A)
			if (_thaiStyle.isFixLineFeed)
			{
				resultString = replace(resultString, String.fromCharCode(0x000D), String.fromCharCode(0x000A));
			}
			//return    
			return resultString;
		}

		private static function setFontFamily(fontFamily:String = PSL_AD_FAMILY):void
		{
			_thaiStyle.fontFamily = fontFamily;
			
			switch (fontFamily)
			{
				case DS_FAMILY:
					//ยกเว้น อ่อ้อ๊อ๋อ์
					//highTone = วรรณยุกต์ = ป่ำป้ำป๊ำป๋ำ
					_HIGHTONE = new String(String.fromCharCode(0x203A) + String.fromCharCode(0x0153) + String.fromCharCode(0x009D) + String.fromCharCode(0x009D) + String.fromCharCode(0xF717) + String.fromCharCode(0x2122) + String.fromCharCode(0x0161));
					//lowTone
					_LOW_TONE = new String(String.fromCharCode(0x2039) + String.fromCharCode(0x0152) + String.fromCharCode(0x008D) + String.fromCharCode(0x008E) + String.fromCharCode(0x008F) + String.fromCharCode(0x0E4D) + String.fromCharCode(0x0E47));
					//วรรณยุกต์ = ป่ป้ป๊ป๋ป์ปํป็
					_LOWERLEFT_TONE = new String(String.fromCharCode(0x2020) + String.fromCharCode(0x2021) + String.fromCharCode(0x02C6) + String.fromCharCode(0x2030) + String.fromCharCode(0x0160) + String.fromCharCode(0x2122) + String.fromCharCode(0x0161));
					//สระซ้าย = ปิปีปึปืปั
					_LOWERLEFT_VOWEL = new String(String.fromCharCode(0x00D4) + String.fromCharCode(0x00D5) + String.fromCharCode(0x00D6) + String.fromCharCode(0x00D7) + String.fromCharCode(0x02DC));
					//สระล่าง = ญุญูญฺ
					_LOWBOTTOM_VOWEL = new String(String.fromCharCode(0x00FC) + String.fromCharCode(0x00FD) + String.fromCharCode(0x00FE));
					//aum = สระอำ
					_AUM_COMBO = new String(String.fromCharCode(0x2122) + String.fromCharCode(0x00D2));
					//ยกเว้น อ่อ้อ๊อ๋อ์,ป่ป้ป๊ป๋ป์ปํป็,ป่ำป้ำป๊ำป๋ำ,อำ
					_ESCAPE_CHAR = new String(String.fromCharCode(0x2039) + String.fromCharCode(0x0152) + String.fromCharCode(0x008D) + String.fromCharCode(0x008E) + String.fromCharCode(0x008F)) + _LOWERLEFT_TONE + _HIGHTONE + new String(String.fromCharCode(0x00D2));
					//ญ,ฐ
					_YOYING_NOTAIL = new String(String.fromCharCode(0x0090));
					_THOTHAN_NOTAIL = new String(String.fromCharCode(0x0080));
					break;
				case PSL_AD_FAMILY:
					//highTone = วรรณยุกต์ = ป่ำป้ำป๊ำป๋ำ
					_HIGHTONE = new String(String.fromCharCode(0x009B) + String.fromCharCode(0x009C) + String.fromCharCode(0x009D) + String.fromCharCode(0x009E) + String.fromCharCode(0x009F) + String.fromCharCode(0x0E4D) + String.fromCharCode(0x0E47));
					//lowTone
					_LOW_TONE = new String(String.fromCharCode(0x008B) + String.fromCharCode(0x008C) + String.fromCharCode(0x008D) + String.fromCharCode(0x008E) + String.fromCharCode(0x008F) + String.fromCharCode(0x0E4D) + String.fromCharCode(0x0E47));
					//tone = วรรณยุกต์ = ป่ป้ป๊ป๋ป์ปํป็
					_LOWERLEFT_TONE = new String(String.fromCharCode(0x0086) + String.fromCharCode(0x0087) + String.fromCharCode(0x0088) + String.fromCharCode(0x0089) + String.fromCharCode(0x008A) + String.fromCharCode(0x0099) + String.fromCharCode(0x009A));
					//lowerleftVowel = สระ = ปิปีปึปืปั
					_LOWERLEFT_VOWEL = new String(String.fromCharCode(0x0081) + String.fromCharCode(0x0082) + String.fromCharCode(0x0083) + String.fromCharCode(0x0084) + String.fromCharCode(0x0098));
					//bottomVowel = สระล่าง = ญุญูญฺ
					_LOWBOTTOM_VOWEL = new String(String.fromCharCode(0xF0FC) + String.fromCharCode(0xF0FD) + String.fromCharCode(0xF0FE));
					//aum = สระอำ
					_AUM_COMBO = new String(String.fromCharCode(0x0099) + String.fromCharCode(0x0E32));
					//ญ,ฐ
					_YOYING_NOTAIL = new String(String.fromCharCode(0xF090));
					_THOTHAN_NOTAIL = new String(String.fromCharCode(0xF080));
					break;
				case PSL_SP_FAMILY:
					//highTone = วรรณยุกต์ = ป่ำป้ำป๊ำป๋ำ
					_HIGHTONE = new String(String.fromCharCode(0xF713) + String.fromCharCode(0xF714) + String.fromCharCode(0xF715) + String.fromCharCode(0xF716) + String.fromCharCode(0xF717) + String.fromCharCode(0x0E4D) + String.fromCharCode(0x0E47));
					//lowTone
					_LOW_TONE = new String(String.fromCharCode(0xF70A) + String.fromCharCode(0xF70B) + String.fromCharCode(0xF70C) + String.fromCharCode(0xF70D) + String.fromCharCode(0xF70E) + String.fromCharCode(0x0E4D) + String.fromCharCode(0x0E47));
					//วรรณยุกต์ = ป่ป้ป๊ป๋ป์ปํป็
					_LOWERLEFT_TONE = new String(String.fromCharCode(0xF705) + String.fromCharCode(0xF706) + String.fromCharCode(0xF707) + String.fromCharCode(0xF708) + String.fromCharCode(0xF709) + String.fromCharCode(0xF711) + String.fromCharCode(0xF712));
					//สระซ้าย = ปิปีปึปืปั
					_LOWERLEFT_VOWEL = new String(String.fromCharCode(0xF701) + String.fromCharCode(0xF702) + String.fromCharCode(0xF703) + String.fromCharCode(0xF704) + String.fromCharCode(0xF710));
					//สระล่าง = ญุญูญฺ
					_LOWBOTTOM_VOWEL = new String(String.fromCharCode(0xF718) + String.fromCharCode(0xF719) + String.fromCharCode(0xF71A));
					//aum = สระอำ
					_AUM_COMBO = new String(String.fromCharCode(0xF711) + String.fromCharCode(0x0E32));
					//ญ,ฐ
					_YOYING_NOTAIL = new String(String.fromCharCode(0xF70F));
					_THOTHAN_NOTAIL = new String(String.fromCharCode(0xF700));
					break;
			}
		}

		public static function setThaiStyle(inputThaiStyle:Object = null):void
		{

			//__________________________________________________________default style

			//fontFamily
			_thaiStyle.fontFamily = PSL_SP_FAMILY;
			//fix
			_thaiStyle.isFixFloat = true;
			_thaiStyle.isFixTail = true;
			_thaiStyle.isFixAum = true;
			_thaiStyle.isFixLowTail = true;
			_thaiStyle.isFixYoying = false;
			_thaiStyle.isFixYoyingTail = true;
			_thaiStyle.isFixLineFeed = false;
			//outputType : multibyte, multibyte_cs, ascii_ps7
			_thaiStyle.outputType = MULTIBYTE;

			//__________________________________________________________custom style

			if (inputThaiStyle != null)
			{
				for (var i:Object in inputThaiStyle)
				{
					_thaiStyle[i] = inputThaiStyle[i];
				}
			}
		}

		//_________________________________________________________________________constructor

		public static function fix(inputString:String, inputThaiStyle:Object = null):String
		{
			//__________________________________________________________set style

			setThaiStyle(inputThaiStyle);

			//__________________________________________________________set table

			setFontFamily(_thaiStyle.fontFamily);

			//__________________________________________________________unicode mapping table

			//วรรณยุกต์ = อ่อ้อ๊อ๋อ์อํอ็
			_TONE = new String(String.fromCharCode(0x0E48) + String.fromCharCode(0x0E49) + String.fromCharCode(0x0E4A) + String.fromCharCode(0x0E4B) + String.fromCharCode(0x0E4C) + String.fromCharCode(0x0E4D) + String.fromCharCode(0x0E47));
			//สระ = อิอีอึอือั
			_VOWEL = new String(String.fromCharCode(0x0E34) + String.fromCharCode(0x0E35) + String.fromCharCode(0x0E36) + String.fromCharCode(0x0E37) + String.fromCharCode(0x0E31));
			//สระล่าง = อุอูอฺ
			_BOTTOM_VOWEL = new String(String.fromCharCode(0x0E38) + String.fromCharCode(0x0E39) + String.fromCharCode(0x0E3A));
			//สระอำ
			_AUM = new String(String.fromCharCode(0x0E33));
			//ปฝฟ
			_LONGTAIL = new String(String.fromCharCode(0x0E1B) + String.fromCharCode(0x0E1D) + String.fromCharCode(0x0E1F));
			//ญญฎฏฐฤฦ
			_LOWTAIL = new String(String.fromCharCode(0xF0AD) + String.fromCharCode(0x0E0D) + String.fromCharCode(0x0E0E) + String.fromCharCode(0x0E0F) + String.fromCharCode(0x0E10) + String.fromCharCode(0x0E24) + String.fromCharCode(0x0E26));
			//ญ,ฐ
			_YOYING = new String(String.fromCharCode(0x0E0D));
			_YOYING_PS7 = new String(String.fromCharCode(0xF0AD));
			_THOTHAN = new String(String.fromCharCode(0x0E10));

			//__________________________________________________________ascii to unicode

			inputString = asciiToUnicode(inputString);

			//__________________________________________________________return

			return applyThaiStyle(inputString);
		}
	}
}
