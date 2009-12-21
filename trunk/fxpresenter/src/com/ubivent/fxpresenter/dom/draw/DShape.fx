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

import com.ubivent.fxpresenter.graphics.Length;
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import javafx.scene.Node;
import com.ubivent.fxpresenter.dom.style.StyleMap;


public abstract class DShape extends PElement, StyledElement {
    public function getX() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "x").value);
    }

    public function getY() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "y").value);
    }

    public function getWidth() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "width").value);
    }

    public function getHeight() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "height").value);
    }

    public abstract function createNode(map : StyleMap) : Node[];

    override public function getStyleList() : Style[] {
            var ret : Style[] = (parent as StyledElement).getStyleList();
            insert TextUtil.getStyleList(this, nsPRESENTATION, "style-name", "presentation") into ret;
            insert TextUtil.getStyleList(this, nsDRAW, "text-style-name", "paragraph") into ret;
            insert TextUtil.getStyleList(this, nsDRAW, "style-name", "graphic") into ret;
            return ret;
    }
}
