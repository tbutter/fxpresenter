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
package com.ubivent.fxpresenter.graphics;

import java.lang.StringBuffer;

public def ENUM_TYPE_MM = 1;
public def ENUM_TYPE_CM = 2;
public def ENUM_TYPE_INCH = 3;
public def ENUM_TYPE_PIXELS = 4;
public def ENUM_TYPE_POINTS = 5;
public def ENUM_TYPE_M = 6;
var dpi : Double = 72;


public function fromString(l : String) : Length {
    if(l.length() == 0) return Length { len: 0 type: ENUM_TYPE_CM };
    var num = new StringBuffer();
    var i = 0;
    if(l.charAt(0) == '-'.charAt(0)) { num.append("-"); i++; }
    while(i < l.length() and (Character.isDigit(l.charAt(i)) or (l.charAt(i) == '.'.charAt(0)))) {
        num.append(l.charAt(i));
        i++;
    }
    var len = Double.parseDouble(num.toString());
    var typestr = l.substring(i);
    
    var type : Integer = ENUM_TYPE_CM;
    if(typestr.equals("cm")) type = ENUM_TYPE_CM;
    if(typestr.equals("pt")) type = ENUM_TYPE_POINTS;
    if(typestr.equals("mm")) type = ENUM_TYPE_MM;
    if(typestr.equals("m")) type = ENUM_TYPE_M;
    if(typestr.equals("px")) type = ENUM_TYPE_PIXELS;
    if(typestr.equals("in")) type = ENUM_TYPE_INCH;
    return Length {len: len type: type};
}

public class Length {
	public-init var len : Double;
	public-init var type : Integer = ENUM_TYPE_CM;

	public function getAsType(out : Integer) : Double {
            if(out == type) return len;
            if(out == ENUM_TYPE_MM) {
                    if(type == ENUM_TYPE_CM) return len * 10;
                    if(type == ENUM_TYPE_M) return len * 1000;
                    if(type == ENUM_TYPE_INCH) return len * 25.4;
                    if(type == ENUM_TYPE_POINTS) return len * 0.352777778;
                    if(type == ENUM_TYPE_PIXELS) return len * 72.0 / dpi * 0.352777778;
            }
            if(out == ENUM_TYPE_CM) {
                    return getAsType(ENUM_TYPE_MM) / 10.0;
            }
            if(out == ENUM_TYPE_M) {
                    return getAsType(ENUM_TYPE_MM) / 1000.0;
            }
            if(out == ENUM_TYPE_INCH) {
                    return getAsType(ENUM_TYPE_MM) / 25.4;
            }
            if(out == ENUM_TYPE_POINTS) {
                    return getAsType(ENUM_TYPE_MM) / 0.352777778;
            }
            if(out == ENUM_TYPE_PIXELS) {
                    return getAsType(ENUM_TYPE_INCH) * dpi;
            }
            return Double.NaN;
	}

	override public function toString() : String {
                if(type == ENUM_TYPE_CM)
			return "{len}cm";
		if(type == ENUM_TYPE_INCH)
			return "{len}inch";
		if(type == ENUM_TYPE_M)
			return "{len}m";
		if(type == ENUM_TYPE_MM)
			return "{len}mm";
		if(type == ENUM_TYPE_PIXELS)
			return "{len}px";
		if(type == ENUM_TYPE_POINTS)
			return "{len}pt";
		return null;
	}

	public function getAsPixel() {
		return getAsType(ENUM_TYPE_PIXELS);
	}

	public function add(offset : Length) : Length {
		len += offset.getAsType(type);
		return this;
	}

	public function minus(offset : Length) : Length {
		len -= offset.getAsType(type);
		return this;
	}

	public function divide(d : Double) {
		len /= d;
		return this;
	}

	public function isBiggerThan(other : Length) : Boolean {
		return this.getAsPixel() > other.getAsPixel();
	}

	public function copy() : Length {
		return Length { type: type len: len};
	}
}
