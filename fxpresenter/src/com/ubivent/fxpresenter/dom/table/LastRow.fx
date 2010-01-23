/*
 * LastRow.fx
 *
 * Created on Jan 22, 2010, 10:18:30 AM
 */

package com.ubivent.fxpresenter.dom.table;

/**
 * @author thomasbutter
 */

public class LastRow extends TableTemplateStyle {
    postinit {
        nsURI = nsTABLE;
        nodeName = "table:last-row";
    }
}
