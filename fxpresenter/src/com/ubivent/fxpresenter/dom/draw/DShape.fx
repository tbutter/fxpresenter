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
package com.ubivent.fxpresenter.dom.draw;

import com.ubivent.fxpresenter.graphics.Length;
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import javafx.scene.Node;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import javafx.scene.transform.Transform;
import javafx.scene.Group;
import javafx.scene.transform.Affine;
import javafx.scene.transform.Translate;
import javafx.scene.transform.Scale;
import javafx.scene.transform.Rotate;
import javafx.util.Math;
import javafx.util.Sequences;


public abstract class DShape extends PElement, StyledElement {
    public function getX() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "x").value);
    }

    public function getY() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "y").value);
    }

    public function getWidth() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "width").value);
    }

    public function getHeight() : Length {
        return Length.fromString(getAttributeNS(nsSVG, "height").value);
    }

    function parseArgs(string : String, cmd : String) : Number[] {
        var str = string;
        var ret : Number[];
        var idx1 : Integer = str.indexOf(" ");
        var idx2 : Integer = str.indexOf(",");
        var idx : Integer = if(idx2 == -1 and idx1 != -1) idx1 else if(idx1 == -1 and idx2 != -1) idx2 else if(idx1 != -1 and idx2 != -1) if(idx1 < idx2) idx1 else idx2 else -1;
        while(idx > -1) {
            var current = str.substring(0, idx).trim();
            str = str.substring(idx+1).trim();
            if(current != "") if(cmd == "translate") insert Length.fromString(current).getAsPixel() into ret else insert Double.parseDouble(current) into ret;
            idx1 = str.indexOf(" ");
            idx2 = str.indexOf(",");
            idx = if(idx2 == -1 and idx1 != -1) idx1 else if(idx1 == -1 and idx2 != -1) idx2 else if(idx1 != -1 and idx2 != -1) if(idx1 < idx2) idx1 else idx2 else -1;
        }
        if(str != "") if(cmd == "translate") insert Length.fromString(str).getAsPixel() into ret else insert Double.parseDouble(str) into ret;
        return ret;
    }

    function getTransform() : Transform[] {
        var transString = getAttributeNS(nsDRAW, "transform").value;
        if(transString == "") return [];
        println("transform {transString}");
        var ret : Transform[] = [];
        transString = transString.trim();
        while(transString != "") {
            var idx = transString.indexOf("(");
            var cmd = transString.substring(0, idx).trim();
            transString = transString.substring(idx+1);
            idx = transString.indexOf(")");
            var argString = transString.substring(0, idx);
            transString = transString.substring(idx+1).trim();
            var args = parseArgs(argString, cmd);
            if(cmd == "matrix") {
                insert Affine { // mxx  mxy  tx myx myy ty
                    mxx: args[0]
                    mxy: args[1]
                    tx: args[2]
                    myx: args[3]
                    myy: args[4]
                    ty: args[5]
                } into ret;
            }
            if(cmd == "translate") {
                println("translate {args[0]}");
                insert Translate {
                    x: args[0]
                    y: if(sizeof args > 1) args[1] else 0
                } into ret;
            }
            if(cmd == "scale") {
                insert Scale {
                    pivotX: 0
                    pivotY: 0
                    x: args[0]
                    y: if(sizeof args > 1) args[1] else args[0]
                } into ret;
            }
            if(cmd == "rotate") {
                println("rotate {Math.toDegrees(args[0])}");
                insert Rotate {
                    pivotX: 0
                    pivotY: 0
                    angle: Math.toDegrees(-args[0])
                } into ret;
            }
            if(cmd == "skewX") {
                println("skewX not implemented"); // TODO implement skewX
            }

            if(cmd == "skewY") {
                println("skewY not implemented"); // TODO implement skewY
            }
        }
        return Sequences.reverse(ret) as Transform[]; // TODO seems to be a oo.o bug!
    }

    public function createNode(map : StyleMap) : Node[] {
        var transforms : Transform [] = getTransform();
        if(sizeof transforms == 0)
            return createUntransformedNode(map);
        var untransformedNodes : Node[] = createUntransformedNode(map);
        if(sizeof untransformedNodes == 0) return untransformedNodes;
        var ret = Group {
            transforms: transforms
            content: untransformedNodes
        }
        println(ret.boundsInLocal);
        return ret;
    }

    public abstract function createUntransformedNode(map : StyleMap) : Node[];

    override public function getStyleList() : Style[] {
            var ret : Style[] = (parent as StyledElement).getStyleList();
            insert TextUtil.getStyleList(this, nsPRESENTATION, "style-name", "presentation") into ret;
            insert TextUtil.getStyleList(this, nsDRAW, "text-style-name", "paragraph") into ret;
            insert TextUtil.getStyleList(this, nsDRAW, "style-name", "graphic") into ret;
            return ret;
    }
}
