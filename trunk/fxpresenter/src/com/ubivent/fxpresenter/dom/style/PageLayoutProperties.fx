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
import com.ubivent.fxpresenter.graphics.Length;
import com.ubivent.fxpresenter.dom.PElement;


public class PageLayoutProperties extends PElement {
    init {
        nsURI = nsSTYLE;
        nodeName = "style:page-layout-properties";
    }

    public function getWidth() : Length {
        return Length.fromString(getAttributeNS(nsFO, "page-width").value);
    }

    public function getHeight() : Length {
        return Length.fromString(getAttributeNS(nsFO, "page-height").value);
    }
}
