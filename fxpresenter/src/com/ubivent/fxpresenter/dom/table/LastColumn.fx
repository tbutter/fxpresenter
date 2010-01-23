/*
 * LastColumn.fx
 *
 * Created on Jan 22, 2010, 10:19:09 AM
 */

package com.ubivent.fxpresenter.dom.table;

/**
 * @author thomasbutter
 */

public class LastColumn extends TableTemplateStyle {
    postinit {
        nsURI = nsTABLE;
        nodeName = "table:last-column";
    }
}
