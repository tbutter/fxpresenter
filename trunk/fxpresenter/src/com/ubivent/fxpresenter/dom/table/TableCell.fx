/*
 * TableCell.fx
 *
 * Created on Jan 19, 2010, 4:39:04 PM
 */

package com.ubivent.fxpresenter.table;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import javafx.scene.Node;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.Group;
import javafx.scene.shape.Rectangle;

/**
 * @author thomasbutter
 */

public class TableCell extends PElement, StyledElement {
    postinit {
        nsURI = nsTABLE;
        nodeName = "table:table-cell";
    }

    public function createNode(map : StyleMap, rownr : Integer, colnr : Integer, left : Length, top : Length, table : Table) : Node[] {
        var width = table.getColWidth(colnr);
        var height = table.getRowHeight(rownr);
        var styles = getStyleList();
        insert table.getTemplateStyle(rownr, colnr) into styles;
        TextUtil.styleToStyleMap(map, styles, this);
        var node = Group {
                content: [
                        if(map.fillColor != null) {
                            Rectangle {
                                x: 0
                                y: 0
                                width: width.getAsPixel()
                                height: height.getAsPixel();
                                fill: map.fillColor
                            }
                        } else [],
                        TextUtil.createTextContentNode(map, this, width, height)
                        ]
               };
        node.layoutX += left.getAsPixel();
        node.layoutY += top.getAsPixel();
        return node;
    }


    public override function getStyleList() : Style[] {
            var ret = (parent as StyledElement).getStyleList();
            insert TextUtil.getStyleList(this, nsTABLE, "style-name", "table-cell" /* TODO ??? */) into ret;
            return ret;
    }
}