/*
 * TableProperties.fx
 *
 * Created on Jan 20, 2010, 6:09:37 PM
 */

package com.ubivent.fxpresenter.dom.style;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.graphics.Length;

/**
 * @author thomasbutter
 */

public class TableProperties extends PElement, StyleProperties {
    override public function addToStyleMap (map : StyleMap, level : Integer) : Void {
        // do nothing
        // TODO fo:background-color
    }

    public function getWidth() : Length {
        return Length.fromString(getAttributeNS(nsSTYLE, "width").value);
    }
}
