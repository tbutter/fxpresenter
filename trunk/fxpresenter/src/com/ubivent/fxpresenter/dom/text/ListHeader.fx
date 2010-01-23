/*
 * ListHeader.fx
 *
 * Created on Jan 19, 2010, 9:53:24 AM
 */

package com.ubivent.fxpresenter.dom.text;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import javafx.scene.Node;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.Group;
import com.ubivent.fxpresenter.dom.style.Style;

/**
 * @author thomasbutter
 */

public class ListHeader extends PElement, StyledElement {
        init {
                nsURI = nsTEXT;
                nodeName = "text:list-header";
	}

	public function getListLevel() : Integer {
		var n = parent;
		while(not (n instanceof TextList)) {
			n = n.parent;
		}
		return (n as TextList).getListLevel();
	}
        
	public override function getStyleList() : Style[] {
		var ret = (parent as StyledElement).getStyleList();
		insert TextUtil.getStyleList(this, nsTEXT, "style-name", "paragraph") into ret;
		return ret;
	}

        public function createNode(map : StyleMap, owidth : Length, height : Length) : Node[] {
            var width = owidth;
            TextUtil.styleToStyleMap(map, getStyleList(), this);

            var group : Group = Group { };
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
                    group.layoutY = height.getAsPixel()-group.layoutBounds.height;
            }
            if (map.textAreaVAlign == "middle") {
                    group.layoutY = (height.getAsPixel()-group.layoutBounds.height)/2;
            }
            return group;
        }
}