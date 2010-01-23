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
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.Node;
import javafx.scene.Group;
import com.ubivent.fxpresenter.dom.text.Paragraph;
import com.ubivent.fxpresenter.dom.text.TextList;
import javafx.scene.layout.VBox;


public class TextBox extends PElement, StyledElement {
        postinit {
		nsURI = nsDRAW;
                nodeName = "draw:text-box";
	}

        public function createNode(map : StyleMap, width : Length, height : Length) : Node[] {
            TextUtil.styleToStyleMap(map, getStyleList(), this);
            return TextUtil.createTextContentNode(map, this, width, height);
        }

	public override function getStyleList() : Style[] {
		var ret = (parent as StyledElement).getStyleList();
		return ret;
	}
}
