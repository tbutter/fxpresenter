/*
 *   Copyright 2009 Thomas Butter, Jens Arndt, Michael Geisser and ubivent GmbH
 *
 *   This file is part of fxpresenter.
 *
 *   fxpresenter is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Lesser General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   fxpresenter is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Lesser General Public License for more details.
 *
 *   You should have received a copy of the GNU Lesser General Public License
 *   along with fxpresenter.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.ubivent.fxpresenter.dom.style;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import javafx.scene.Node;
import com.ubivent.fxpresenter.dom.draw.DShape;
import java.lang.String;


public class MasterPage extends PElement, StyledElement {
    override var nsURI = nsSTYLE;
    override var nodeName = "style:master-page";

    public function getPageLayout() : PageLayout {
        println(getAttribute("style:page-layout-name").value);
        var ret = doc.getElementWithAttribute(nsSTYLE, "page-layout", "style:name", getAttribute("style:page-layout-name").value) as PageLayout;
    }

    override public function toString() {
            return "Master {getAttributeNS(nsSTYLE,'name')}";
    }

    public function getMasterPage() {
            return null;
    }

    public function createNode(styles : StyleMap) : Node[] {
            TextUtil.styleToStyleMap(styles, getStyleList(), this);
            var ret : Node[] = [];
            for(node in children) {
                if(node instanceof DShape) {
                    var elem = node as DShape;
                    var presclass : String = elem.getAttributeNS(nsPRESENTATION, "class").value;
                    if(presclass == null)
                            insert elem.createNode(styles) into ret
                    else {
                            if(presclass.equals("header")) {
                                    if(styles.displayHeader)
                                            insert elem.createNode(styles) into ret;
                            }
                            if(presclass.equals("footer")) {
                                    if(styles.displayFooter)
                                            insert elem.createNode(styles) into ret;
                            }
                            if(presclass.equals("date-time")) {
                                    if(styles.displayDateTime)
                                            insert elem.createNode(styles) into ret;
                            }
                            if(presclass.equals("page-number")) {
                                    if(styles.displayPageNumber)
                                            insert elem.createNode(styles) into ret;
                            }
                    }
                }
            }
            return ret;
    }

    override public function getStyleList() {
        var ret : Style[] = [];
        insert TextUtil.getStyleList(doc.getDefaultStyle("graphic",this)) into ret;
        insert TextUtil.getStyleList(this, nsDRAW, "style-name", "drawing-page") into ret;
        return ret;
    }

}
