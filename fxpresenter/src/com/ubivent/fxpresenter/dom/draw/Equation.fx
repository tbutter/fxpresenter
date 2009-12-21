/*
 *   Copyright 2009 Thomas Butter, Jens Arndt, Michael Geisser and ubivent GmbH
 *
 *   This file is part of fxpresenter.
 *
 *   fxpresenter is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Lesser General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   fxpresenter is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Lesser General Public License for more details.
 *
 *   You should have received a copy of the GNU Lesser General Public License
 *   along with fxpresenter.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.ubivent.fxpresenter.dom.draw;

import com.ubivent.fxpresenter.dom.PElement;


public class Equation extends PElement {

	init {
		nsURI = nsDRAW;
                nodeName = "draw:equation";
	}

	public function getEquationName() : String {
		return getAttributeNS(nsDRAW, "name").value;
	}

	public function calc() : Double {
		var formula : String = getAttributeNS(nsDRAW, "formula").value;
                var ee : EquationElement = parse(formula);
                return ee.evaluate();
        }

	function parseFunction(s : String) : EquationElement {
		var state = 0; // before string 0, in function name 1, in parentheses 2
		var parentheses = 0;
		var ret : EquationElement = null;
		var argstart = 0;
                var slen = s.length();
                for(i in [0..<slen]) {
                        if(state == 0) {
				if((s.charAt(i) <= 'z'.charAt(0) and s.charAt(i) >= 'a'.charAt(0)))
                                        state = 1
				else return null;
                        }
                        if(state == 1) {
				if(s.charAt(i) == '('.charAt(0)) {
					state = 2;
					ret = EquationElement { equation: this type: EquationElement.FUNCTION value: s.substring(0,i) };
					argstart = i+1;
				}
				else if(not ((s.charAt(i) <= 'z'.charAt(0) and s.charAt(i) >= 'a'.charAt(0))
                                    or (s.charAt(i) <= '9'.charAt(0) and s.charAt(i) >= '0'.charAt(0)))) return null;
                        } else if(state == 2) {
				if(s.charAt(i) == '('.charAt(0)) parentheses++;
				if(s.charAt(i) == ')'.charAt(0)) parentheses--;
				if( (parentheses < 0) and (i < (s.length()-1)) ) return null;
				if(s.charAt(i) == ','.charAt(0) and parentheses == 0) {
					insert (parse(s.substring(argstart, i))) into ret.children;
					argstart = i+1;
				}
			}
		}
                insert parse(s.substring(argstart, s.length()-1)) into ret.children;
		return ret;
	}

	function parse(so : String) : EquationElement {
		var s : String = so.trim();
		if(s.length() == 0) return null;
		if(isNumber(s)) return EquationElement { equation: this type : EquationElement.NUMBER value: s };
		if(isIdentifier(s)) return EquationElement { equation: this type: EquationElement.IDENTIFIER value: s };
		if(isFunctionReference(s)) return EquationElement { equation: this type: EquationElement.FUNCTIONREFERENCE value: s.substring(1)};
		if(isModifierReference(s)) return EquationElement { equation: this type : EquationElement.MODIFIERREFERENCE value: s.substring(1)};
		// functions
		var ee : EquationElement = parseFunction(s);
		if(ee != null) return ee;

		// parentheses
		var parentheses = 0;
		if(s.charAt(0) == '('.charAt(0)) {
			if(s.charAt(s.length()-1) == ')'.charAt(0)) {
				var i = 1;
				parentheses = 1;
				while((i < s.length()-1) and (parentheses > 0)) {
					var c = s.charAt(i);
					if(c == '('.charAt(0)) parentheses++;
					if(c == ')'.charAt(0)) parentheses--;
					i++;
				}
				if(parentheses > 0) {
					return parse(s.substring(1, s.length()-1));
				}
			}
		}

		// additive expression
		parentheses = 0;
		for(i in [0..<s.length()]) {
			var c = s.charAt(i);
			if(c == '('.charAt(0)) parentheses++;
			if(c == ')'.charAt(0)) parentheses--;
			if(parentheses < 0) { println("null parentheses! "); return null; }
			if(c == '+'.charAt(0)) {
				if(i == 0 or i == s.length()-1) { println("starts with + "); return null; }
				var s1 = s.substring(0, i);
				var s2 = s.substring(i+1);
				return EquationElement { equation: this type: EquationElement.ADDITION value: "+" children: [parse(s1), parse(s2)]};
			}
			if(c == '-'.charAt(0)) {
				if(i == 0 or i == s.length()-1) { println("starts with - "); return null; }
				var s1 = s.substring(0, i);
				var s2 = s.substring(i+1);
				return EquationElement { equation: this type: EquationElement.SUBSTRACTION value: "-" children: [parse(s1), parse(s2)]};
			}
		}

		parentheses = 0;
		for(i in [0..<s.length()]) {
			var c = s.charAt(i);
			if(c == '('.charAt(0)) parentheses++;
			if(c == ')'.charAt(0)) parentheses--;
			if(parentheses < 0) { println("no parentheses"); return null; }
			if(c == '*'.charAt(0)) {
				if(i == 0 or i == s.length()-1)  { println("starts with *"); return null; }
				var s1 = s.substring(0, i);
				var s2 = s.substring(i+1);
				return EquationElement { equation: this type: EquationElement.MULTIPLICATION value: "*" children: [parse(s1), parse(s2)]};
			}
			if(c == '/'.charAt(0)) {
				if(i == 0 or i == s.length()-1) { println("starts with /"); return null; }
				var s1 = s.substring(0, i);
				var s2 = s.substring(i+1);
				return EquationElement { equation: this type: EquationElement.DIVISION value: "/" children: [parse(s1), parse(s2)]};
			}
		}
                println("unknown expression {s}");
		return null;
	}

	function isFunctionReference(s : String) : Boolean {
		if(not s.startsWith("?")) return false;
		if(s.length() <= 1) return false;
		if(not containsAlphaOrDigits(s.substring(1))) return false;
		return true;
	}

	function isModifierReference(s : String) {
		if(not s.startsWith("$")) return false;
		if(s.length() <= 1) return false;
		if(not containsDigits(s.substring(1))) return false;
		return true;
	}

	function containsAlphaOrDigits(s : String) : Boolean {
		if(s.length()==0) return false;
		for(i in [0..<s.length()]) {
			if(not ( isDigit(s.charAt(i)) or isAlpha(s.charAt(i)) ) ) return false;
		}
		return true;
	}

	function containsDigits(s : String) : Boolean {
		if(s.length()==0) return false;
		for(i in [0..<s.length()]) {
			if(not isDigit(s.charAt(i))) return false;
		}
		return true;
	}


	function isAlpha(c : Integer) {
		if((c >= 'a'.charAt(0) and c <= 'z'.charAt(0)) or c >= 'A'.charAt(0) and c <= 'Z'.charAt(0)) return true;
		return false;
	}

	function isIdentifier(s : String) : Boolean {
		if(s.equals("pi") or s.equals("left") or s.equals("top") or s.equals("right") or s.equals("bottom") or
				s.equals("xstretch") or s.equals("ystretch") or s.equals("hasstroke") or s.equals("hasfill") or
				s.equals("width") or s.equals("height") or s.equals("logwidth") or s.equals("logheight")) {
			return true;
		}
		return false;
	}

	function isNumber(s : String) : Boolean {
		var hasDecimalPoint = false;
		var isNegative = false;
		if(s.length()==0) return false;
		for(i in [0..<s.length()]) {
			if(s.charAt(i) == '-'.charAt(0) and i == 0) isNegative = true
			else if(s.charAt(i) == '.'.charAt(0) and  not hasDecimalPoint and i != 0 and i != s.length()-1) hasDecimalPoint = true
			else if(not isDigit(s.charAt(i))) return false;
		}
		return true;
	}

	function isDigit(c : Integer) : Boolean {
		if(c >= '0'.charAt(0) and c <= '9'.charAt(0)) return true;
		return false;
	}
}
