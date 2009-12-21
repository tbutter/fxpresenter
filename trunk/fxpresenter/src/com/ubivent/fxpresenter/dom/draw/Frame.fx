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
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import javafx.scene.Group;
import javafx.scene.Node;
import com.ubivent.fxpresenter.dom.draw.TextBox;


public class Frame extends DShape, StyledElement {

	postinit {
            nsURI = nsDRAW;
            nodeName = "draw:frame";
	}

	override public function createNode(pmap : StyleMap) : Node[] {
                var map = StyleMap{};
                TextUtil.styleToStyleMap(map, getStyleList(), this);
                var g = Group {
                    layoutX: getX().getAsPixel();
                    layoutY: getY().getAsPixel();
                };
		for(node in children) {
			if(node instanceof DImage) {
                                insert (node as DImage).createNode(getWidth(), getHeight()) into g.content;
			} else if(node instanceof TextBox) {
                                insert (node as TextBox).createNode(map, getWidth(), getHeight()) into g.content;
			} else {
                            println("Frame unknown {node.nodeName}");
                        }

		}
                return g;
	}
}
