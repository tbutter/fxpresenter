/*
 * TableColumn.fx
 *
 * Created on Jan 19, 2010, 4:05:51 PM
 */

package com.ubivent.fxpresenter.table;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import com.ubivent.fxpresenter.graphics.Length;
import com.ubivent.fxpresenter.dom.style.StyleUtil;

/**
 * @author thomasbutter
 */

public class TableColumn extends PElement, StyledElement {
    postinit {
        nsURI = nsTABLE;
        nodeName = "table:table-column";
    }

    public override function getStyleList() : Style[] {
        var ret = (parent as StyledElement).getStyleList();
        insert TextUtil.getStyleList(this, nsTABLE, "style-name", "table-column") into ret;
        return ret;
    }

    public function getWidth() : Length {
        Length.fromString(StyleUtil.getStyleAttribute(getStyleList(), nsSTYLE, "table-column-properties", nsSTYLE, "column-width"));
    }
}