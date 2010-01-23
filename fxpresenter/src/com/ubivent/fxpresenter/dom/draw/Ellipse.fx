/*
 * Ellipse.fx
 *
 * Created on Jan 23, 2010, 5:48:59 PM
 */

package com.ubivent.fxpresenter.dom.draw;

import com.ubivent.fxpresenter.dom.style.StyleMap;
import javafx.scene.Node;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import javafx.scene.Group;

/**
 * @author thomasbutter
 */

public class Ellipse  extends DShape {
    override public function createNode (map : StyleMap) : Node[] {
        TextUtil.styleToStyleMap(map, getStyleList(), this);
        var ellipse = javafx.scene.shape.Ellipse {
            centerX: getWidth().getAsPixel()/2
            centerY: getHeight().getAsPixel()/2
            radiusX: getWidth().getAsPixel()/2
            radiusY: getHeight().getAsPixel()/2
        };
        map.setStyles(ellipse);
        Group {
            layoutX: getX().getAsPixel()
            layoutY: getY().getAsPixel()
            content:
                [
                    ellipse,
                    TextUtil.createTextContentNode(map, this, getWidth(), getHeight())
                ]
         }
    }

    postinit {
            nsURI = nsDRAW;
            nodeName = "draw:ellipse";
    }
}