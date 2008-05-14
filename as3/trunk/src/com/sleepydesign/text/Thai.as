/**
 * 
 * Thai.as (Sleepy Type Tool) version 1.3.4 AS3
 * 
 * @author		katopz@sleepydesign.com
 * @version		1.3.4
 * @see 		http://services.sleepydesign.com/typetool/
 * @see 		http://code.google.com/p/sleepytypetool/
 * 
*/
 
/**
* Copyright (C) 2005-2008 Todsaporn Banjerdkit (katopz), sleepydesign.com.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this 
* software and associated documentation files (the "Software"), to deal in the Software 
* without restriction, including without limitation the rights to use, copy, modify, 
* merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
* permit persons to whom the Software is furnished to do so, subject to the following 
* conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies 
* or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
* PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
* CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
* OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
*/
 
/**
* 
* + features
*   - จัดตำแหน่งตำแหน่งสระ/วรรณยุกต์ ที่ลอย หรือทับหาง 
*   - แก้ไขปัญหาการแสดงผล ญ ในโปรแกรม Adobe Photoshop 7
*   - แก้ไขปัญหาภาษาไทยพิมพ์ไม่ได้ในโปรแกรม Adobe CS,CS2,CS3
*   - สร้าง embed font สำหรับ Flash
*   - ตัวปัดบรรทัด(0x0D0A)ตัด Carriage Return(0x0D)+ Line Feed(0x0A) เหลือแค่ (0x0A)
*   - ยกเลิกการแก้ไขจากตัวที่แก้ (fix)ไปแล้ว (beta)
*    
* + TODO
* 	- clean up code
* 	- RegExp
* 
* + target
*   - อ่อ้อ๊อ๋อ์อํอ็ป่ป้ป๊ป๋ป์ปํป็อั่อั้อั๊อั๋ปั่ปั้ปั๊ปั๋อิ่อี้อึ๊อื๋ปิ่ปี้ปึ๊ปื๋ปิ์อำอ่ำอ้ำอ๊ำอ๋ำปำป่ำป้ำป๊ำป๋ำปุ่ปุ้ปุ๊ปุ๋อุอูอฺญญุญูญฺฤุฤูฤฺฎุฎูฎฺฏุฏูฏฺฐฐุฐูฐฺ
* 
* + thaiStyle
*  - {isFixFloat:true, isFixTail:true, isFixAum:true, isFixLowTail:true, isFixYoying:false, isFixYoyingTail:true}
* 
* + fontFamily
*   - psl_ad = PSL-AD,DB-,JS-,Courier
*   - psl_sp = PSL,PSL-SP,NP,UPC,DSE,Tahoma,TH
*   - ds = DS-
* 
* + outputType
*   - multibyte
*   - multibyte_cs
*   - ascii_ps7
* 
* + method #1
*   - var target:Thai = new Thai(inputString, inputThaiStyle) 
* 
* + method #2
*   - var target:Thai = new Thai(inputString) 
*   - target.setThaiStyle(inputThaiStyle) 
*   - target.applyThaiStyle()
*   - target.removeThaiStyle()
* 
* + method #3
*   - var target:Thai = new Thai().getEmbedString();
* 
*/

package com.sleepydesign.text
{
	import flash.events.EventDispatcher;
	
	public class Thai extends EventDispatcher {
		
		//____________________________________________________________style
		
		private var thaiStyle		:Object = new Object();
		
		//____________________________________________________________static
		
		private var tone			:String;
		private var vowel			:String;
		private var bottomVowel		:String;
		private var aum				:String;
		private var longTail		:String;
		private var lowTail			:String;
		private var yoying			:String;
		private var yoyingPS7		:String;
		private var yoyingNoTail	:String;
		private var thothan			:String;
		private var thothanNoTail	:String;
		
		//____________________________________________________________dynamic
		
		private var highTone		:String;
		private var lowTone			:String;
		private var lowerleftTone	:String;
		private var lowerleftVowel	:String;
		private var lowBottomVowel	:String;
		private var aumCombo		:String;
		private var escapeChar		:String;
		
		private var value			:String;
		
		//__________________________________________________________function
		
		private function fixYoYing(target:String=""):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			var resultString:String = "";
			if (thaiStyle.isFixYoying || thaiStyle.isFixYoyingTail) {
				for (var i = 0; i<target.length; i++) {
					//char by char
					var char = target.charAt(i);
					//skip some
					var isEscape:Boolean = (escapeChar != null) && (escapeChar.indexOf(char)>-1);
					//char code
					var charCode = Number(target.charCodeAt(i));
					//skip newline
					var isNewline:Boolean = (char == "\n");
					if (!isNewline && ((yoying+thothan).indexOf(char)>-1)) {
						//next is bottomVowel?
						var isBeforeBottomVowel:Boolean = (bottomVowel.indexOf(target.charAt(i+1))>-1) && (i+1<target.length);
						
						//_________________________________________________________________________ญ
						
						if (charCode == Number(yoying.charCodeAt(0))) {
							//isFixYoying
							if (thaiStyle.isFixYoying) {
								char = yoyingPS7;
							}
							//isFixYoyingTail                
							if (thaiStyle.isFixYoyingTail && isBeforeBottomVowel) {
								char = yoyingNoTail;
							}
						}
						
						//_________________________________________________________________________ฐ                
						
						if (charCode == Number(thothan.charCodeAt(0))) {
							//isFixYoyingTail
							if (thaiStyle.isFixYoyingTail && isBeforeBottomVowel) {
								char = thothanNoTail;
							}
						}
						resultString += char;
					} else {
						resultString += target.charAt(i);
					}
				}
			} else {
				return target;
			}
			//return
			return resultString;
		}
		
		public function getEmbedString():String {
			var resultString:String = "";
			//normal
			for (var i = 20; i<255; i++) {
				resultString += String.fromCharCode(i);
			}
			//fix
			resultString += highTone+lowTone+lowerleftTone+lowerleftVowel+lowBottomVowel+aumCombo+yoyingNoTail+thothanNoTail;
			//return
			return resultString;
		}
		
		public function asciiToUnicode(target:String=""):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			//result                
			var resultString:String = "";
			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				//only thai and not fixed
				var charCode = Number(target.charCodeAt(i));
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if (!isNewline) {
					if ((charCode>127) && (charCode<3584) && (charCode<0xF000)) {
						//ascii -> unicode
						charCode = charCode+3585-161;
					}
					resultString += String.fromCharCode(charCode);
				} else {
					resultString += char;
				}
			}
			//return
			return resultString;
		}
		
		public function unicodeToAscii(target:String=""):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			//result                
			var resultString:String = "";
			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				//only thai and not fixed
				var charCode = Number(target.charCodeAt(i));
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if (!isNewline) {
					if ((charCode>3584) && (charCode<0xF000)) {
						//unicode ->ascii
						charCode = charCode-3585+161;
					}
					if (charCode<128) {
						resultString += char;
					} else {
						resultString += String.fromCharCode(charCode);
					}
				} else {
					resultString += char;
				}
			}
			//return
			return resultString;
		}
		
		private function ps7Chr(target:String=""):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			var resultString:String = "";
			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				//is that bottomVowel?
				var isLowBottomVowel:Boolean = (lowBottomVowel.indexOf(char)>-1);
				//skip some
				var isEscape :Boolean= (escapeChar != null) && (escapeChar.indexOf(char)>-1);
				//char code
				var charCode = Number(target.charCodeAt(i));
				//skip newline
				var isNewline:Boolean = (char == "\n");
				//only thai and not fixed
				if (!isNewline && !isLowBottomVowel && (charCode>3584) && !isEscape) {
					//unicode ->ascii
					charCode = charCode-3585+161;
					resultString += String.fromCharCode(charCode);
				} else {
					resultString += target.charAt(i);
				}
			}
			//return
			return resultString;
		}
		
		private function csChr(target:String=""):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			//result                
			var resultString:String = "";
			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				//only thai and not fixed
				var charCode = Number(target.charCodeAt(i));
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if (!isNewline) {
					if ((charCode>3584) && (charCode<0xF000)) {
						//unicode ->ascii
						charCode = charCode-3585+161;
					}
					if (charCode<126) {
						resultString += char;
					} else {
						resultString += String.fromCharCode("0xF0"+charCode.toString(16));
					}
				} else {
					resultString += char;
				}
			}
			//return
			return resultString;
		}
		
		private function removeCSChr(target:String=""):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			//result                
			var resultString:String = "";
			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				//only thai and not fixed
				var charCode = Number(target.charCodeAt(i));
				//skip newline
				var isNewline:Boolean = ((char == "\n") || (charCode == 13));
				if ((!isNewline) && (charCode>128)) {
					if ((charCode>3584) && (charCode<0xF000)) {
						//unicode ->ascii
						charCode = -charCode+3585-161;
					}
					//resultString += String.fromCharCode(charCode-0xF000+3585-161);          
					if (charCode<126) {
						resultString += char;
					} else {
						resultString += String.fromCharCode(charCode-0xF000+3585-161);
						//resultString += String.fromCharCode("0xF0"+charCode.toString(16));
					}
				} else {
					resultString += char;
				}
			}
			//return
			return resultString;
		}
		
		private function removePS7Chr(target:String=""):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			var resultString:String = "";
			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				//is that bottomVowel?
				var isLowBottomVowel:Boolean = (lowBottomVowel.indexOf(char)>-1);
				//skip some
				var isEscape:Boolean = (escapeChar != null) && (escapeChar.indexOf(char)>-1);
				//char code
				var charCode = Number(target.charCodeAt(i));
				//skip newline
				var isNewline:Boolean = (char == "\n");
				//only thai and not fixed
				if (!isNewline && !isLowBottomVowel && (charCode<3584-21) && !isEscape) {
					//unicode ->ascii
					charCode = charCode+3585-161;
					resultString += String.fromCharCode(charCode);
				} else {
					charCode = charCode-3585+161;
					resultString += String.fromCharCode(charCode);
				}
			}
			//return
			return resultString;
		}
		
		public function removeThaiStyle(target:String="", inputThaiStyle:Object=null):String {
			//default
			if (target == "") {
				target = new String(value);
			}
			if (inputThaiStyle == null) {
				inputThaiStyle = thaiStyle
			}
			if (inputThaiStyle.fontFamily == null) {
				inputThaiStyle.fontFamily = "psl_ad";
			}
			//result                
			//setFontFamily
			setFontFamily(inputThaiStyle.fontFamily);
			//prepare asciiToUnicode
			if (inputThaiStyle.fontFamily == "psl_ad") {
				switch (inputThaiStyle.outputType) {
				case "multibyte_cs" :
					target = removeCSChr(target);
					yoyingPS7 = asciiToUnicode(yoyingPS7);
					yoyingNoTail = asciiToUnicode(yoyingNoTail);
					thothanNoTail = asciiToUnicode(thothanNoTail);
					//is that fixed? highTone,lowTone,lowerleftTone,lowerleftVowel,lowBottomVowel,aumCombo
					highTone = asciiToUnicode(highTone);
					lowTone = asciiToUnicode(lowTone);
					lowerleftTone = asciiToUnicode(lowerleftTone);
					lowerleftVowel = asciiToUnicode(lowerleftVowel);
					lowBottomVowel = asciiToUnicode(lowBottomVowel);
					//What's this [0],[1] for huh?,I almost fogot this 2 lines ;|
					//aumCombo[0] = asciiToUnicode(aumCombo[0]);
					//aumCombo[1] = asciiToUnicode(aumCombo[1]);
					aumCombo = asciiToUnicode(aumCombo);
					break;
				case "ascii_ps7" :
					target = removePS7Chr(target);
					break;
				}
			}
			
			//result       
			var resultString:String = "";
			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				
				//is that fixed? yoying,thothan
				var yoyingPS7Pos = yoyingPS7.indexOf(char);
				var yoyingNoTailPos = yoyingNoTail.indexOf(char);
				var thothanNoTailPos = thothanNoTail.indexOf(char);
				
				//is that fixed? highTone,lowTone,lowerleftTone,lowerleftVowel,lowBottomVowel,aumCombo
				var highTonePos = highTone.indexOf(char);
				var lowTonePos = lowTone.indexOf(char);
				var lowerleftTonePos = lowerleftTone.indexOf(char);
				var lowerleftVowelPos = lowerleftVowel.indexOf(char);
				var lowBottomVowelPos = lowBottomVowel.indexOf(char);
				var aumComboPos_0 = aumCombo.charAt(0).indexOf(char);
				var aumComboPos_1 = aumCombo.charAt(1).indexOf(char);
				
				//unfix : yoying,thothan
				if (yoyingPS7Pos>-1) {
					char = yoying.charAt(0);
				}
				if (yoyingNoTailPos>-1) {
					char = yoying.charAt(0);
				}
				if (thothanNoTailPos>-1) {
					char = thothan.charAt(0);
				}
				//unfix : tone,vowel,bottomVowel,aum                
				if (highTonePos>-1) {
					char = tone.charAt(highTonePos);
				}
				if (lowTonePos>-1) {
					char = tone.charAt(lowTonePos);
				}
				if (lowerleftTonePos>-1) {
					char = tone.charAt(lowerleftTonePos);
				}
				if (lowerleftVowelPos>-1) {
					char = vowel.charAt(lowerleftVowelPos);
				}
				if (lowBottomVowelPos>-1) {
					char = bottomVowel.charAt(lowBottomVowelPos);
				}
				if ((aumComboPos_0>-1) && (aumComboPos_1>-1) && ((aumComboPos_1-aumComboPos_0) == 1)) {
					char = aum.charAt(aumComboPos_0);
				}
				
				//grab                
				resultString += char;
			}
			if (inputThaiStyle.fontFamily != "psl_ad") {
				switch (inputThaiStyle.outputType) {
				case "multibyte_cs" :
					resultString = removeCSChr(resultString);
					break;
				case "ascii_ps7" :
					//need fix
					resultString = removePS7Chr(resultString);
					break;
				}
			}
			//return     
			return resultString;
		}
		
		private function fixFloat(target:String=""):String {
			//default
			if (target == "") {
				var target = new String(value);
			}
			//result                
			var resultString:String = "";

			for (var i = 0; i<target.length; i++) {
				//char by char
				var char = target.charAt(i);
				
				//________________________________________________________________long tail		
				
				var isAfterLongTail:Boolean = (longTail.indexOf(target.charAt(i-1))>-1) && (i>=1);
				var isAfter2LongTail:Boolean = (longTail.indexOf(target.charAt(i-2))>-1) && (i>=2);
				
				//________________________________________________________________vowel		
				
				//is that  vowel?
				var vowelPos = vowel.indexOf(char);
				//lowerleftVowel = สระ = ปิปีปึปืปั
				if (thaiStyle.isFixTail && (vowelPos>-1) && isAfterLongTail) {
					char = lowerleftVowel.charAt(vowelPos);
				}
				//is that bottomVowel?                
				var bottomVowelPos = bottomVowel.indexOf(char);
				
				//________________________________________________________________tone		
				
				//is that tone?
				var tonePos = tone.indexOf(char);
				//skip newline
				var isNewline:Boolean = (char == "\n");
				//previous char is tone
				var isAfterTone:Boolean = (tone.indexOf(target.charAt(i-1))>-1) && (i>=1);				
				//tone found
				if (!isNewline && thaiStyle.isFixFloat && (tonePos>-1)) {
					//next is aum?
					var isBeforeAum:Boolean = (aum.indexOf(target.charAt(i+1))>-1) && (i+1<target.length);
					//prev is vowel?
					var isAfterVowel:Boolean = (vowel.indexOf(target.charAt(i-1))>-1) && (i>=1);
					//prev is lowvowel?
					var isAfterLowVowel:Boolean = (lowerleftVowel.indexOf(target.charAt(i-1))>-1) && (i>=1);
					if (!isAfterTone && !isBeforeAum && !isAfterVowel) {
						if (thaiStyle.isFixTail && isAfterLongTail) {
							//avoid tail by move high tone to lower left 
							char = lowerleftTone.charAt(tonePos);
						} else {
							//just pull 'em down
							char = lowTone.charAt(tonePos);
						}
					}
					if (thaiStyle.isFixTail) {
						var isAfterBottomVowel = (bottomVowel.indexOf(target.charAt(i-1))>-1)&& (i>=1);
						if (isAfter2LongTail && (isAfterVowel || isAfterLowVowel)) {
							//highTone = ปิ่ปิ้ปิ๊ปิ๋
							char = highTone.charAt(tonePos);
						} else if (isAfter2LongTail && isAfterBottomVowel) {
							//bottomVowel = ปุ่ปุ้ปุ๊ปุ๋
							char = lowerleftTone.charAt(tonePos);
						} else if (isAfterLongTail && isBeforeAum) {
							//highTone = ป่ำป้ำป๊ำป๋ำ      
							char = highTone.charAt(tonePos);
						}
					}
				}
				
				//________________________________________________________________bottomVowel
				
				//is that bottomVowel?
				var isAfterLowTail:Boolean = (lowTail.indexOf(target.charAt(i-1))>-1) && (i>=1);
				//ญุญูญฺ	
				if ((bottomVowelPos>-1) && isAfterLowTail && thaiStyle.isFixLowTail) {
					char = lowBottomVowel.charAt(bottomVowelPos);
				}
				
				//________________________________________________________________aum
				
				//is that aum?
				var isAum:Boolean = (aum.indexOf(char) > -1);
				var isAfterLongTailTone:Boolean = isAfter2LongTail && isAfterTone;
				//ปำฟำฝำ,ป่ำป้ำป๊ำป๋ำ
				if (thaiStyle.isFixAum && isAum && (isAfterLongTail || isAfterLongTailTone)) {
					//break aum
					char = aumCombo;
				}
				//grab                
				resultString += char;
			}
			//return
			return resultString;
		}
		
		private function replace(target:String, source_chr:String="", replace_chr:String=""):String {
			//default
			if (target == "") {
				var target = new String(value);
			}
			//result                
			var resultString = target.split(source_chr).join(replace_chr);
			//return
			return resultString;
		}
		
		public function applyThaiStyle(target:String=""):String {
			//default
			if (target == "") {
				var target = new String(value);
			}
			//result                
			var resultString:String = "";
			//fix Yoying
			target = fixYoYing(target);
			//fix Float
			target = fixFloat(target);
			//outputType : multibyte_cs, ascii_ps7, multibyte
			switch (thaiStyle.outputType) {
			case "multibyte_cs" :
				resultString = csChr(target);
				break;
			case "ascii_ps7" :
				resultString = ps7Chr(target);
				break;
			default :
				resultString = target;
				break;
			}
			//fix newline (0x0D0A->0x0A)
			if (thaiStyle.isFixLineFeed) {
				resultString = replace(resultString, String.fromCharCode(0x000D), String.fromCharCode(0x000A));
			}
			//return    
			return resultString;
		}
		
		private function setFontFamily(fontFamily:String="") {
			if (fontFamily == "") {
				thaiStyle.fontFamily = "psl_ad";
			} else {
				thaiStyle.fontFamily = fontFamily;
			}
			switch (fontFamily) {
			case "ds" :
				//ยกเว้น อ่อ้อ๊อ๋อ์
				//highTone = วรรณยุกต์ = ป่ำป้ำป๊ำป๋ำ
				highTone = new String(String.fromCharCode(0x203A)+String.fromCharCode(0x0153)+String.fromCharCode(0x009D)+String.fromCharCode(0x009D)+String.fromCharCode(0xF717)+String.fromCharCode(0x2122)+String.fromCharCode(0x0161));
				//lowTone
				lowTone = new String(String.fromCharCode(0x2039)+String.fromCharCode(0x0152)+String.fromCharCode(0x008D)+String.fromCharCode(0x008E)+String.fromCharCode(0x008F)+String.fromCharCode(0x0E4D)+String.fromCharCode(0x0E47));
				//วรรณยุกต์ = ป่ป้ป๊ป๋ป์ปํป็
				lowerleftTone = new String(String.fromCharCode(0x2020)+String.fromCharCode(0x2021)+String.fromCharCode(0x02C6)+String.fromCharCode(0x2030)+String.fromCharCode(0x0160)+String.fromCharCode(0x2122)+String.fromCharCode(0x0161));
				//สระซ้าย = ปิปีปึปืปั
				lowerleftVowel = new String(String.fromCharCode(0x00D4)+String.fromCharCode(0x00D5)+String.fromCharCode(0x00D6)+String.fromCharCode(0x00D7)+String.fromCharCode(0x02DC));
				//สระล่าง = ญุญูญฺ
				lowBottomVowel = new String(String.fromCharCode(0x00FC)+String.fromCharCode(0x00FD)+String.fromCharCode(0x00FE));
				//aum = สระอำ
				aumCombo = new String(String.fromCharCode(0x2122)+String.fromCharCode(0x00D2));
				//ยกเว้น อ่อ้อ๊อ๋อ์,ป่ป้ป๊ป๋ป์ปํป็,ป่ำป้ำป๊ำป๋ำ,อำ
				escapeChar = new String(String.fromCharCode(0x2039)+String.fromCharCode(0x0152)+String.fromCharCode(0x008D)+String.fromCharCode(0x008E)+String.fromCharCode(0x008F))+lowerleftTone+highTone+new String(String.fromCharCode(0x00D2));
				//ญ,ฐ
				yoyingNoTail = new String(String.fromCharCode(0x0090));
				thothanNoTail = new String(String.fromCharCode(0x0080));
				break;
			case "psl_ad" :
				//highTone = วรรณยุกต์ = ป่ำป้ำป๊ำป๋ำ
				highTone = new String(String.fromCharCode(0x009B)+String.fromCharCode(0x009C)+String.fromCharCode(0x009D)+String.fromCharCode(0x009E)+String.fromCharCode(0x009F)+String.fromCharCode(0x0E4D)+String.fromCharCode(0x0E47));
				//lowTone
				lowTone = new String(String.fromCharCode(0x008B)+String.fromCharCode(0x008C)+String.fromCharCode(0x008D)+String.fromCharCode(0x008E)+String.fromCharCode(0x008F)+String.fromCharCode(0x0E4D)+String.fromCharCode(0x0E47));
				//tone = วรรณยุกต์ = ป่ป้ป๊ป๋ป์ปํป็
				lowerleftTone = new String(String.fromCharCode(0x0086)+String.fromCharCode(0x0087)+String.fromCharCode(0x0088)+String.fromCharCode(0x0089)+String.fromCharCode(0x008A)+String.fromCharCode(0x0099)+String.fromCharCode(0x009A));
				//lowerleftVowel = สระ = ปิปีปึปืปั
				lowerleftVowel = new String(String.fromCharCode(0x0081)+String.fromCharCode(0x0082)+String.fromCharCode(0x0083)+String.fromCharCode(0x0084)+String.fromCharCode(0x0098));
				//bottomVowel = สระล่าง = ญุญูญฺ
				lowBottomVowel = new String(String.fromCharCode(0xF0FC)+String.fromCharCode(0xF0FD)+String.fromCharCode(0xF0FE));
				//aum = สระอำ
				aumCombo = new String(String.fromCharCode(0x0099)+String.fromCharCode(0x0E32));
				//ญ,ฐ
				yoyingNoTail = new String(String.fromCharCode(0xF090));
				thothanNoTail = new String(String.fromCharCode(0xF080));
				break;
			case "psl_sp" :
				//highTone = วรรณยุกต์ = ป่ำป้ำป๊ำป๋ำ
				highTone = new String(String.fromCharCode(0xF713)+String.fromCharCode(0xF714)+String.fromCharCode(0xF715)+String.fromCharCode(0xF716)+String.fromCharCode(0xF717)+String.fromCharCode(0x0E4D)+String.fromCharCode(0x0E47));
				//lowTone
				lowTone = new String(String.fromCharCode(0xF70A)+String.fromCharCode(0xF70B)+String.fromCharCode(0xF70C)+String.fromCharCode(0xF70D)+String.fromCharCode(0xF70E)+String.fromCharCode(0x0E4D)+String.fromCharCode(0x0E47));
				//วรรณยุกต์ = ป่ป้ป๊ป๋ป์ปํป็
				lowerleftTone = new String(String.fromCharCode(0xF705)+String.fromCharCode(0xF706)+String.fromCharCode(0xF707)+String.fromCharCode(0xF708)+String.fromCharCode(0xF709)+String.fromCharCode(0xF711)+String.fromCharCode(0xF712));
				//สระซ้าย = ปิปีปึปืปั
				lowerleftVowel = new String(String.fromCharCode(0xF701)+String.fromCharCode(0xF702)+String.fromCharCode(0xF703)+String.fromCharCode(0xF704)+String.fromCharCode(0xF710));
				//สระล่าง = ญุญูญฺ
				lowBottomVowel = new String(String.fromCharCode(0xF718)+String.fromCharCode(0xF719)+String.fromCharCode(0xF71A));
				//aum = สระอำ
				aumCombo = new String(String.fromCharCode(0xF711)+String.fromCharCode(0x0E32));
				//ญ,ฐ
				yoyingNoTail = new String(String.fromCharCode(0xF70F));
				thothanNoTail = new String(String.fromCharCode(0xF700));
				break;
			}
		}
		
		public function setThaiStyle(inputThaiStyle:Object=null) {
			
			//__________________________________________________________default style
			
			//fontFamily
			thaiStyle.fontFamily = "psl_ad";
			//fix
			thaiStyle.isFixFloat = true;
			thaiStyle.isFixTail = true;
			thaiStyle.isFixAum = true;
			thaiStyle.isFixLowTail = true;
			thaiStyle.isFixYoying = false;
			thaiStyle.isFixYoyingTail = true;
			thaiStyle.isFixLineFeed = false;
			//outputType : multibyte, multibyte_cs, ascii_ps7
			thaiStyle.outputType = "multibyte";
			
			//__________________________________________________________custom style
			
			if (inputThaiStyle != null) {
				for (var i in inputThaiStyle) {
					thaiStyle[i] = inputThaiStyle[i];
				}
			}
		}
		
		//_________________________________________________________________________constructor
		
		public function Thai(inputString:String="", inputThaiStyle:Object=null) {
			
			//__________________________________________________________set style
			
			setThaiStyle(inputThaiStyle);
			
			//__________________________________________________________set table
			
			setFontFamily(thaiStyle.fontFamily);
			
			//__________________________________________________________unicode mapping table
			
			//วรรณยุกต์ = อ่อ้อ๊อ๋อ์อํอ็
			tone = new String(String.fromCharCode(0x0E48)+String.fromCharCode(0x0E49)+String.fromCharCode(0x0E4A)+String.fromCharCode(0x0E4B)+String.fromCharCode(0x0E4C)+String.fromCharCode(0x0E4D)+String.fromCharCode(0x0E47));
			//สระ = อิอีอึอือั
			vowel = new String(String.fromCharCode(0x0E34)+String.fromCharCode(0x0E35)+String.fromCharCode(0x0E36)+String.fromCharCode(0x0E37)+String.fromCharCode(0x0E31));
			//สระล่าง = อุอูอฺ
			bottomVowel = new String(String.fromCharCode(0x0E38)+String.fromCharCode(0x0E39)+String.fromCharCode(0x0E3A));
			//สระอำ
			aum = new String(String.fromCharCode(0x0E33));
			//ปฝฟ
			longTail = new String(String.fromCharCode(0x0E1B)+String.fromCharCode(0x0E1D)+String.fromCharCode(0x0E1F));
			//ญญฎฏฐฤฦ
			lowTail = new String(String.fromCharCode(0xF0AD)+String.fromCharCode(0x0E0D)+String.fromCharCode(0x0E0E)+String.fromCharCode(0x0E0F)+String.fromCharCode(0x0E10)+String.fromCharCode(0x0E24)+String.fromCharCode(0x0E26));
			//ญ,ฐ
			yoying = new String(String.fromCharCode(0x0E0D));
			yoyingPS7 = new String(String.fromCharCode(0xF0AD));
			thothan = new String(String.fromCharCode(0x0E10));
			
			//__________________________________________________________ascii to unicode
			
			inputString = asciiToUnicode(inputString);
			
			//__________________________________________________________return
			
			if (inputString != null) {
				value = applyThaiStyle(inputString);
			} else {
				value = "";
			}
		}
		
		override public function toString() :String{
			return value;
		}
	}
}
