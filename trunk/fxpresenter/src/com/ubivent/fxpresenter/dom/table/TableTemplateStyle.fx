/*
 * TableTemplateStyle.fx
 *
 * Created on Jan 22, 2010, 10:17:03 AM
 */

package com.ubivent.fxpresenter.dom.table;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.style.Style;

/**
 * @author thomasbutter
 */

public class TableTemplateStyle extends PElement {
    public function getStyle() : Style {
        doc.getStyle(getAttributeNS(nsTEXT, "style-name").value, "table-cell", this)
    }
}
