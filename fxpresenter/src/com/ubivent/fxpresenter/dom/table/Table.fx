/*
 * Table.fx
 *
 * Created on Jan 19, 2010, 3:41:14 PM
 */

package com.ubivent.fxpresenter.table;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.Node;
import com.ubivent.fxpresenter.dom.table.TableTemplate;

/**
 * @author thomasbutter
 */

public class Table extends PElement, StyledElement {
    postinit {
        nsURI = nsTABLE;
        nodeName = "table:table";
    }

    public override function getStyleList() : Style[] {
        var ret = (parent as StyledElement).getStyleList();
        insert TextUtil.getStyleList(this, nsTABLE, "style-name", "table") into ret;
        return ret;
    }

    public function getColWidth(colnr : Integer) : Length {
        var column = getElementsByTagNameNS(nsTABLE, "table-column")[colnr] as TableColumn;
        return column.getWidth();
    }

    public function getRowHeight(rownr : Integer) : Length {
        var row = getElementsByTagNameNS(nsTABLE, "table-row")[rownr] as TableRow;
        return row.getHeight();
    }

    public function getTemplateStyle(rownr : Integer, colnr : Integer) : Style[] {
        var template = doc.getStyle(getAttributeNS(nsTABLE, "template-name").value, "table-template", this) as TableTemplate;
        var ret : Style[] = [];
        if(rownr > 0 and colnr > 0) {
            insert template.getAdditionalStyles("body") into ret;
        }
        if(rownr mod 2 == 1) {
            insert template.getAdditionalStyles("odd-row") into ret;
        }
        if(colnr mod 2 == 1) {
            insert template.getAdditionalStyles("odd-column") into ret;
        }
        if(rownr == 0) {
            if(getAttributeNS(nsTABLE, "use-first-row-styles").value == "true") {
                insert template.getAdditionalStyles("first-row") into ret;
            }
        }
        if(colnr == 0) {
            if(getAttributeNS(nsTABLE, "use-first-column-styles").value == "true") {
                insert template.getAdditionalStyles("first-column") into ret;
            }
        }
        var rowCount = sizeof getElementsByTagNameNS(nsTABLE, "table-row");
        var colCount = sizeof getElementsByTagNameNS(nsTABLE, "table-column");
        if(rownr == rowCount-1) {
            if(getAttributeNS(nsTABLE, "use-last-row-styles").value == "true") {
                insert template.getAdditionalStyles("last-row") into ret;
            }
        }
        if(colnr == colCount-1) {
            if(getAttributeNS(nsTABLE, "use-last-column-styles").value == "true") {
                insert template.getAdditionalStyles("last-column") into ret;
            }
        }
        ret;
    }


    public function createNode(map : StyleMap, width : Length, height : Length) : Node[] {
        var ret : Node[] = [];
        var rownr = 0;
        var colnr = 0;
        var left : Length;
        var top : Length = Length.fromString("0cm");
        for(row in getElementsByTagNameNS(nsTABLE, "table-row")) {
            left = Length.fromString("0cm");
            colnr = 0;
            for(elem in row.children where elem instanceof PElement) {
                var col = elem as PElement;
                if(col.nodeName == "table:covered-table-cell") colnr++;
                if(col.nodeName == "table:table-cell") {
                    insert (col as TableCell).createNode(map, rownr, colnr, left, top, this) into ret;
                    colnr++;
                }
                left = left.add(getColWidth(colnr-1));
            }
            top = top.add(getRowHeight(rownr));
            rownr++;
        }
        return ret;
    }
}