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
import java.lang.String;
import java.lang.Thread;


public class GraphicProperties extends PElement, StyleProperties {
        postinit {
                nsURI = nsSTYLE;
                nodeName = "style:graphic-properties";
	}


	override public function addToStyleMap(map : StyleMap, level : Integer) {
                var fillcolor = getAttributeNS(nsDRAW, "fill-color").value;
		if(fillcolor != null and fillcolor != "") {
                        map.fillColor = Color.web(fillcolor);
		}
		var fill = getAttributeNS(nsDRAW, "fill").value;
		if(fill != null and fill != "") {
                        map.fillType = fill;
                }
		var opacity : String = getAttributeNS(nsDRAW, "opacity").value;
		if(opacity != null and opacity != "") map.opacity = Float.parseFloat(opacity.substring(0, opacity.length()-1)) / 100;
		var stroke : String = getAttributeNS(nsDRAW, "stroke").value;
		if(stroke != null and stroke != "") {
                        map.stroke = stroke;
                }
		var strokecolor : String = getAttributeNS(nsSVG, "stroke-color").value;
		if(strokecolor != null and strokecolor != "") {
                        map.strokeColor = Color.web(strokecolor);
                }
		var marker : String = getAttributeNS(nsDRAW, "marker-end").value;
		if(marker != null and marker != "") map.markerEnd = marker;
		marker = getAttributeNS(nsDRAW, "marker-start").value;
		if(marker != null and marker != "") map.markerStart = marker;
		var valign = getAttributeNS(nsDRAW, "textarea-vertical-align").value;
		if(valign != null and valign != "") {
			map.textAreaVAlign = valign;
		}
	}
}
