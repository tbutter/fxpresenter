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
import java.lang.String;
import javafx.scene.text.TextAlignment;

public class ParagraphProperties extends PElement, StyleProperties {
        postinit {
		nsURI = nsSTYLE;
                nodeName = "style:paragraph-properties";
	}

	override public function addToStyleMap(map : StyleMap, level : Integer) : Void {
                var tmp : String = getAttributeNS(nsFO, "text-align").value;
		if(tmp != null and tmp != "") {
			if(tmp.equals("start"))
				map.textAlign = TextAlignment.LEFT;
			if(tmp.equals("right"))
				map.textAlign = TextAlignment.RIGHT;
			if(tmp.equals("center")) {
				map.textAlign = TextAlignment.CENTER;
			}
		}
		tmp = getAttributeNS(nsFO, "text-indent").value;
		if(tmp != null and tmp != "") {
			map.textIndent = Length.fromString(tmp);
		}
		tmp = getAttributeNS(nsFO, "margin-left").value;
		if(tmp != null and tmp != "") {
			map.marginLeft = Length.fromString(tmp);
		}
		tmp = getAttributeNS(nsFO, "margin-right").value;
		if(tmp != null and tmp != "") {
			map.marginRight = Length.fromString(tmp);
		}
		tmp = getAttributeNS(nsFO, "margin-top").value;
		if(tmp != null and tmp != "") {
			map.marginTop = Length.fromString(tmp);
		}
		tmp = getAttributeNS(nsFO, "margin-bottom").value;
		if(tmp != null and tmp != "") {
			map.marginBottom = Length.fromString(tmp);
		}
		tmp = getAttributeNS(nsTEXT, "enable-numbering").value;
		if(tmp != null and tmp != "") {
			if(tmp.equals("false")) map.enableNumbering = false;
		}
	}
}
