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
package com.ubivent.fxpresenter.dom.text;

import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.dom.style.StyleProperties;
import java.lang.Void;


public class ListStyle extends Style {

	postinit {
            nsURI = nsTEXT;
            nodeName = "text:list-style";
	}

	override public function getFamily() {
		return "list";
	}

	override public function addToStyleMap(map : StyleMap, level : Integer) {
            for(node in children) {
                if(node instanceof ListLevelStyle) {
                        var lls = node as ListLevelStyle;
                        if(lls.getLevel() == level) {
                                (node as StyleProperties).addToStyleMap(map, level);
                        }
                }
            }
	}
}
