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
import javafx.util.Sequences;
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.PNode;
import com.ubivent.fxpresenter.dom.style.Style;
import java.lang.String;
import java.lang.System;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import javafx.scene.Group;
import javafx.scene.Node;
import com.ubivent.fxpresenter.graphics.Length;

public function styleToStyleMap(map : StyleMap, styles : Style[], elem : PNode ) : Void {
		var level = 0;
		if(elem instanceof ListItem) {
			level = (elem as ListItem).getListLevel();
		}
		if(elem instanceof Paragraph) {
			if(elem.parent instanceof ListItem) {
				level = (elem.parent as ListItem).getListLevel();
			}
		}
		if(elem instanceof Span) {
			if(elem.parent.parent instanceof ListItem) {
				level = (elem.parent.parent as ListItem).getListLevel();
			}
		}
		for(s in styles) {
			(s as Style).addToStyleMap(map,level);
		}
	}

public function getStyleList(style : Style) : Style[] {
        getStyleList(style, []);
}

public function getStyleList(style : Style, alreadyIncluded : Style[]) : Style[] {
        var list : Style[] = [];
        var parentname : String = style.getAttributeNS(PNode.nsSTYLE, "parent-style-name").value;
        if(parentname != "") {
                //println("parentname {parentname} {style.getStyleName()}");
                var parent : Style = style.doc.getStyle(parentname, style.getFamily(), style);
                if(parent == null) {
                    println("parent not found! {parentname} {style.getFamily()}");
                } else if(Sequences.indexOf(alreadyIncluded,parent) > -1) {
                        System.out.println("circular dependency in style {style}");
                }
                insert getStyleList(parent as Style) before list[0];
        }
        insert style into list;
        return list;
}

public function getStyleList(n : PElement, namespace : String, name : String, family : String) : Style[] {
        var stylename : String = n.getAttributeNS(namespace, name).value;
        if(stylename != "") {
                //println("stylename {stylename}");
                var style : Style = n.doc.getStyle(stylename, family, n);
                if(style != null) return getStyleList(style);
        }
        return [];
}

public function createTextContentNode(map : StyleMap, elem : PElement, width : Length, height : Length) : Node {
            var group : Group = Group {};
            var yOffset : Number = 0;
            for(node in elem.children) {
                var n : Node[] = [];
                if (node instanceof Paragraph) {
                       n = (node as Paragraph).createNode(map, width, height);
                }
                if (node instanceof TextList) {
                       n = (node as TextList).createNode(map, width, height);
                }
                if(sizeof n > 0) {
                    var h : Number = 0;
                    for(tn in n) {
                        tn.layoutY += yOffset;
                        if(h < tn.layoutBounds.height) h = tn.layoutBounds.height;
                    }
                    yOffset += h;
                    insert n into group.content;
                }
            }
            if (map.textAreaVAlign == "bottom") {
                    group.layoutY = height.getAsPixel()-group.layoutBounds.height;
            }
            if (map.textAreaVAlign == "middle") {
                    group.layoutY = (height.getAsPixel()-group.layoutBounds.height)/2;
            }
            return group;
}

public class TextUtil {

}
