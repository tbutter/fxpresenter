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
                if(Sequences.indexOf(alreadyIncluded,parent) > -1) {
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



public class TextUtil {

}
