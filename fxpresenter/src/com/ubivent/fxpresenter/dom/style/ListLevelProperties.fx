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
import java.util.HashMap;


public class ListLevelProperties extends PElement, StyleProperties {
        postinit {
                nsURI = nsSTYLE;
                nodeName = "style:list-level-properties";
	}

	override public function addToStyleMap(map : StyleMap, level : Integer) {
                var tmp : String = getAttributeNS(nsTEXT, "min-label-width").value;
		if(tmp != null and tmp != "") {
			map.minLabelWidth = Length.fromString(tmp);
		}
		tmp = getAttributeNS(nsTEXT, "space-before").value;
		if(tmp != null and tmp != "") {
			map.spaceBefore = Length.fromString(tmp);
		}
	}
}
