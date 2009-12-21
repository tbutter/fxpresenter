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

import com.ubivent.fxpresenter.dom.style.StyleMap;

public class ListLevelStyleBullet extends ListLevelStyle {

	postinit {
            nsURI = nsTEXT;
            nodeName = "text:list-level-style-bullet";
	}


	override public function addToStyleMap(map : StyleMap, level : Integer) {
            map.listLevelType = "bullet";
            map.listBulletChar = getAttributeNS(nsTEXT, "bullet-char").value;
            super.addToStyleMap(map, level);
	}
}
