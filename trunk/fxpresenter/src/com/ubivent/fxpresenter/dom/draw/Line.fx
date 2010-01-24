/*
 * Line.fx
 *
 * Created on Jan 19, 2010, 12:09:11 PM
 */

package com.ubivent.fxpresenter.dom.draw;

import com.ubivent.fxpresenter.graphics.Length;
import java.lang.UnsupportedOperationException;
import com.sun.javafx.runtime.sequence.Sequence;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import javafx.scene.Node;
import java.lang.Thread;

/**
 * @author thomasbutter
 */

public class Line extends DShape {

        postinit {
		nsURI = nsDRAW;
                nodeName = "draw:line";
	}

	override public function getX() : Length {
		if(getX1().isBiggerThan(getX2())) return getX2();
		return getX1();
	}

	override public function getY() : Length{
		if(getY1().isBiggerThan(getY2())) return getY2();
		return getY1();
	}

	override public function getHeight() : Length {
		if(getY1().isBiggerThan(getY2())) return getY1().minus(getY2());
		return getY2().minus(getY1());
	}

	override public function getWidth() : Length {
		if(getX1().isBiggerThan(getX2())) return getX1().minus(getX2());
		return getX2().minus(getX1());
	}

	public function getX1() : Length {
		return Length.fromString(getAttributeNS(nsSVG, "x1").value);
	}

	public function getX2() : Length {
		return Length.fromString(getAttributeNS(nsSVG, "x2").value);
	}

	public function getY1() : Length {
		return Length.fromString(getAttributeNS(nsSVG, "y1").value);
	}

	public function getY2() : Length {
		return Length.fromString(getAttributeNS(nsSVG, "y2").value);
	}

        override public function createUntransformedNode (map : StyleMap) : Node[] {
                TextUtil.styleToStyleMap(map, getStyleList(), this);
                var line = javafx.scene.shape.Line {
                    startX: getX1().getAsPixel()
                    startY: getY1().getAsPixel()
                    endX: getX2().getAsPixel()
                    endY: getY2().getAsPixel()
                };
                map.setStyles(line);
                line;
	}
}
