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


import com.ubivent.fxpresenter.dom.style.MasterPage;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import javafx.scene.Node;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;
import com.ubivent.fxpresenter.dom.style.StyleMap;

public class Page extends PElement, StyledElement {
        override var nsURI = nsDRAW;
        override var nodeName = "draw:page";

	public function getMasterPage() : MasterPage {
		return doc.getMasterPage(getAttributeNS(nsDRAW,"master-page-name").value);
	}

	public function getPageName() : String {
		return getAttributeNS(nsDRAW, "name").value;
	}

	public function getWidth() : Length {
		return getMasterPage().getPageLayout().getPLProperties().getWidth();
	}

	public function getHeight() : Length {
		return getMasterPage().getPageLayout().getPLProperties().getHeight();
	}

	public function createNode() : Node {
                var style = getStyleList();
                var map = StyleMap {};
                var group = Group {};
		insert getMasterPage().createNode(map) into group.content;
                TextUtil.styleToStyleMap(map, style, this);
                insert Rectangle {
                    x: 0
                    y: 0
                    width: getWidth().getAsPixel();
                    height: getHeight().getAsPixel();
                    fill: map.pageColor
                    id: "page"
                } before group.content[0];
		for(node in children) {
			if(node instanceof DShape) {
                                insert (node as DShape).createNode(map) into group.content;
			} else {
                            println("unknown page child {node.nodeName}");
                        }

		}
                return group;
	}

	override public function getStyleList() : Style[] {
		var ret  = getMasterPage().getStyleList();
		insert TextUtil.getStyleList(this, nsDRAW, "style-name", "drawing-page") into ret;
		return ret;
	}
}
