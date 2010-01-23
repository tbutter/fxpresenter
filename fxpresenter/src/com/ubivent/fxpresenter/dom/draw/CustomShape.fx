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
import javafx.scene.layout.VBox;
import com.ubivent.fxpresenter.dom.text.Paragraph;
import com.ubivent.fxpresenter.dom.text.TextList;
import javafx.scene.Node;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;


public class CustomShape extends DShape, StyledElement {

	postinit {
		nsURI = nsDRAW;
                nodeName = "draw:custom-shape";
	}

	override public function createNode(pmap : StyleMap) {
		TextUtil.styleToStyleMap(pmap, getStyleList(), this);
                var g = Group {
                    layoutX: getX().getAsPixel();
                    layoutY: getY().getAsPixel();
                };
                for(node in children) {
                        if(node instanceof DImage) {
                                println("CustomShape drawing DImage");
				insert (node as DImage).createNode(getWidth(), getHeight()) into g.content;
			} else if(node instanceof EnhancedGeometry) {
                                println("CustomShape EnhancedGeometry");
                                insert (node as EnhancedGeometry).createNode(pmap, getWidth(), getHeight()) into g.content;
                        }
		}
                var group : Group = Group {};
                var yOffset : Number = 0;
                for(node in children) {
                    var n : Node[];
                    if (node instanceof Paragraph) {
                           n = (node as Paragraph).createNode(pmap, getWidth(), getHeight());
                    }
                    if (node instanceof TextList) {
                           n = (node as TextList).createNode(pmap, getWidth(), getHeight());
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
                if (pmap.textAreaVAlign == "bottom") {
                        group.layoutY = getHeight().getAsPixel()-group.boundsInLocal.height;
                }
                if (pmap.textAreaVAlign == "middle") {
                        group.layoutY = (getHeight().getAsPixel()-group.boundsInLocal.height)/2;
                }
                if(sizeof group.content > 0) insert group into g.content;
                return [g];
	}
}
