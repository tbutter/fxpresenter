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
package com.ubivent.fxpresenter.dom.style;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.paint.Color;
import javafx.scene.text.FontWeight;
import java.lang.Void;

public class TextProperties extends PElement, StyleProperties {

	postinit {
                nsURI = nsSTYLE;
                nodeName = "style:text-properties";
	}

	override public function addToStyleMap(map: StyleMap, level : Integer) {
                var tmp : String = getAttributeNS(nsFO, "font-size").value;
		if(tmp != null and tmp != "") {
                        if(not tmp.endsWith("%")) {
				var len = Length.fromString(tmp);
				map.fontSize = len;
			} else {
				var oldlen = map.fontSize;
				if(oldlen != null) {
					var percent : Float = Float.parseFloat(tmp.substring(0, tmp.lastIndexOf('%')));
					map.fontSize = oldlen.divide(1.0 / (percent / 100.0));
				}
			}
		}
		tmp = getAttributeNS(nsFO, "font-family").value;
		if(tmp != null and tmp != "") {
			if(tmp.startsWith("'")) {
				tmp = tmp.substring(1, tmp.length()-1);
			}
			map.fontFamily = tmp;
		}
		tmp = getAttributeNS(nsSTYLE, "text-underline-style").value;
		if(tmp != null and tmp != "") {
			map.underline = tmp;
		}
		var tmpc = Color.web(getAttributeNS(nsFO, "color").value);
		if(tmpc != null) {
                        map.textColor = tmpc;
		}
		tmp = getAttributeNS(nsFO, "font-weight").value;
		if(tmp != null and tmp != "") {
			if(tmp.equals("normal")) map.weight = FontWeight.REGULAR
			else if(tmp.equals("bold")) map.weight = FontWeight.BOLD
		}
	}
}