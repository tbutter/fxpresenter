/*
 * TableTemplate.fx
 *
 * Created on Jan 22, 2010, 9:54:49 AM
 */

package com.ubivent.fxpresenter.dom.table;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.style.Style;

/**
 * @author thomasbutter
 */

public class TableTemplate extends Style {
    postinit {
        nsURI = nsTABLE;
        nodeName = "table:table-template";
    }

    override public function getFamily() {
            return "table-template";
    }

    public function getAdditionalStyles(type : String) : Style[] {
        var ret : Style[] = [];
        for(elem in getElementsByTagNameNS(nsTABLE, type)) {
            insert (elem as TableTemplateStyle).getStyle() into ret;
        }
        ret;
    }

    override public function getStyleName() : String {
            return getAttributeNS(nsTEXT, "style-name").value;
    }

    public function getTableTemplateName() : String {
            return getAttributeNS(nsTEXT, "style-name").value;
    }
}
