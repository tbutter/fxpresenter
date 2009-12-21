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
import javafx.scene.paint.Color;
import com.ubivent.fxpresenter.dom.PNode;
import java.lang.String;

public class DrawingPageProperties extends PElement, StyleProperties {
        postinit {
		nsURI = nsSTYLE;
                nodeName = "style:drawing-page-properties";
	}

	override public function addToStyleMap(map : StyleMap, level : Integer) {
		//Color fillcolor = GraphicProperties.parseColor(getAttributeNS(nsDRAW, "fill-color"));
		//if(fillcolor != null) {
		//	map.put(StyleKey.PAGECOLOR, fillcolor);
		//}
		var fillcolor : Color = Color.web(getAttributeNS(nsDRAW, "fill-color").value);
		if(fillcolor != null) {
			map.fillColor = fillcolor;
		}
		var fill : String = getAttributeNS(nsDRAW, "fill").value;
		if(fill != null and fill != "") map.fillType = fill;
		var fillimage : String = getAttributeNS(nsDRAW, "fill-image-name").value;
		if(fillimage != null and fillimage != "") { // Find draw:fill-image
			var node : PNode = this;
			while(not(node.localName.equals("document-styles") or node.localName.equals("document-content"))) node = node.parent;
			var nl = (node as PElement).getElementsByTagNameNS(nsDRAW, "fill-image");
			for(n in nl) {
				if(n.getAttributeNS(nsDRAW, "name").value.equals(fillimage)) {
					map.fillImageName = n.getAttributeNS(nsXLINK, "href").value;
				}
			}
		}
		var bool : String = getAttributeNS(nsPRESENTATION,"display-header").value;
		if(bool != null and bool.equals("true")) {
			map.displayHeader = true;
		} else {
			map.displayHeader = false;
		}
		bool = getAttributeNS(nsPRESENTATION,"display-footer").value;
		if(bool != null and bool.equals("true")) {
			map.displayFooter = true;
		} else {
			map.displayFooter = false;
		}
		bool = getAttributeNS(nsPRESENTATION,"display-page-number").value;
		if(bool != null and bool.equals("true")) {
			map.displayPageNumber = true;
		} else {
			map.displayPageNumber = false;
		}
		bool = getAttributeNS(nsPRESENTATION,"display-date-time").value;
		if(bool != null and bool.equals("true")) {
			map.displayDateTime = true;
		} else {
			map.displayDateTime = false;
		}
	}
}
