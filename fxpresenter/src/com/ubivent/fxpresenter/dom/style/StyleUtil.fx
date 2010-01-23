/*
 * StyleUtil.fx
 *
 * Created on Jan 20, 2010, 9:08:41 PM
 */

package com.ubivent.fxpresenter.dom.style;

/**
 * @author thomasbutter
 */

public function getStyleAttribute(styles : Style[], styleNS : String, styleName : String, attribNS: String, attribName : String) {
    var ret : String = "";
    for(style in styles) {
        for(elem in style.getElementsByTagNameNS(styleNS, styleName)) {
                var val = elem.getAttributeNS(attribNS, attribName).value;
                if(val != null and val != "") {
                    ret = val;
                }
        }
    }
    return ret;
}


public class StyleUtil {

}
