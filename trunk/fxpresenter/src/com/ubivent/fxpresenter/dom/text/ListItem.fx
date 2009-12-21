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
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.Node;
import javafx.scene.text.Text;
import javafx.scene.text.TextOrigin;
import javafx.scene.Group;

public class ListItem extends PElement, StyledElement {
        init {
                nsURI = nsTEXT;
                nodeName = "text:list-item";
	}

	public function getListLevel() : Integer {
		var n = parent;
		while(not (n instanceof TextList)) {
			n = n.parent;
		}
		return (n as TextList).getListLevel();
	}

	public function getLocalNumber() : Integer {
		var start = getAttributeNS(nsTEXT, "start-value").value;
		if(start != null) {
			return Integer.parseInt(start);
		}
		var n = getPreviousSibling();
		while(n != null) {
			if(n instanceof ListItem) return (n as ListItem).getLocalNumber()+1;
			n = n.getPreviousSibling();
		}
		return 1;
	}

	public function getItemNumber() : Integer[] {
                var number : Integer[] = getLocalNumber();
		if(getListLevel() == 1) return number;
		var n = parent;
		while(not (n instanceof ListItem)) {
			n = n.parent;
		}
		insert (n as ListItem).getItemNumber() before number[0];
		return number;
	}

	public override function getStyleList() : Style[] {
		var ret = (parent as StyledElement).getStyleList();
		insert TextUtil.getStyleList(this, nsTEXT, "style-name", "paragraph") into ret;
		return ret;
	}

        public function createNode(map : StyleMap, owidth : Length, height : Length) : Node[] {
            var width = owidth;
            TextUtil.styleToStyleMap(map, getStyleList(), this);
            var outerGroup = Group {};

            var drawBullet = false;

            // check if paragraph has text:enable-numbering="false"
            if(children[0] instanceof Paragraph) {
                    var styles = (children[0] as StyledElement).getStyleList();
                    var styleMap = StyleMap {};
                    TextUtil.styleToStyleMap(styleMap, styles, children[0]);
                    drawBullet = styleMap.enableNumbering;
            }

            var itemstring = "*";
            if(map.listLevelType == "bullet") {
                itemstring = map.listBulletChar;
            }
            var mt = Text {
                textOrigin: TextOrigin.BASELINE
                content: itemstring
            };
            map.setStyles(mt);
            width.minus(Length { type: Length.ENUM_TYPE_PIXELS len: mt.layoutBounds.width});
            var group : Group = Group { layoutX : mt.layoutBounds.width };
            var hasContent = false;
            var firstBaseline : Number = 0;
            var yOffset : Number = 0;
            for(node in children) {
                var n : Node[];
                if (node instanceof Paragraph) {
                       hasContent = true;
                       n = (node as Paragraph).createNode(map, width, height);
                       if(firstBaseline == 0) firstBaseline = (node as Paragraph).firstBaseline;
                }
                if (node instanceof TextList) {
                       n = (node as TextList).createNode(map, width, height);
                }
                if(sizeof n > 0) {
                    var h : Number = 0;
                    for(tn in n) {
                        tn.layoutY += yOffset;
                        if(h < tn.layoutBounds.height) h = tn.boundsInLocal.height; // TODO should by layoutBounds?
                    }
                    yOffset += h;
                    insert n into group.content;
                }
            }
            if (map.textAreaVAlign == "bottom") {
                    outerGroup.layoutY = height.getAsPixel()-group.layoutBounds.height;
            }
            if (map.textAreaVAlign == "middle") {
                    outerGroup.layoutY = (height.getAsPixel()-group.layoutBounds.height)/2;
            }
            mt.layoutY = firstBaseline;
            if(drawBullet and hasContent) outerGroup.content = mt;
            insert group into outerGroup.content;
            return [
                    outerGroup];
        }
}
