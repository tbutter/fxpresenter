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
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.draw.TextBox;
import com.ubivent.fxpresenter.dom.style.Style;
import javafx.scene.Node;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.Group;


public class TextList extends PElement, StyledElement {
        init {
                nsURI = nsTEXT;
                nodeName = "text:list";
	}

	public function getListLevel() : Integer {
		var n = parent;
		while( n != null) {
			if(n instanceof TextBox) return 1;
			if(n instanceof TextList) {
				var level = (n as TextList).getListLevel()+1;
				return level;
			}
			n = n.parent;
		}
		return 1;
	}

	public override function getStyleList() : Style[] {
		var ret = (parent as StyledElement).getStyleList();
		insert TextUtil.getStyleList(this, nsTEXT, "style-name", "list") into ret;
		return ret;
	}

        public function createNode(map : StyleMap, width : Length, height : Length) : Node[] {
            var ret : Group = Group {};
            var yOffset : Number = 0;
            for(node in children) {
                var n : Node[];
                if(node instanceof ListItem) {
                    n = (node as ListItem).createNode(map, width, height);
                }
                if(node instanceof ListHeader) {
                    n = (node as ListHeader).createNode(map, width, height);
                }
                if(sizeof n > 0) {
                    var h : Number = 0;
                    for(tn in n) {
                        tn.layoutY += yOffset;
                        if(h < tn.layoutBounds.height) h = tn.layoutBounds.height;
                    }
                    yOffset += h;
                    insert n into ret.content;
                }
            }
            return ret;
        }
}
