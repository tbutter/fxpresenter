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

import javafx.scene.paint.Color;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.text.TextAlignment;
import javafx.scene.text.FontWeight;
import javafx.scene.text.Font;
import javafx.scene.Node;
import javafx.scene.shape.Shape;
import javafx.scene.text.Text;
import javafx.scene.paint.Paint;


public class StyleMap {
    public var fillColor : Paint;
    public var pageColor : Paint = Color.WHITE;
    public var fillType : String = "solid";
    public var fillImageName : String = null;
    public var displayHeader : Boolean;
    public var displayFooter : Boolean;
    public var displayPageNumber : Boolean;
    public var displayDateTime : Boolean;
    public var opacity : Float = 1.0;
    public var stroke : String;
    public var strokeColor : Color = Color.BLACK;
    public var markerStart : String;
    public var markerEnd : String;
    public var textAreaVAlign : String;
    public var minLabelWidth : Length;
    public var spaceBefore : Length;
    public var textAlign : TextAlignment;
    public var textIndent : Length;
    public var marginLeft: Length;
    public var marginRight: Length;
    public var marginTop: Length;
    public var marginBottom: Length;
    public var enableNumbering : Boolean = true;
    public var fontSize : Length;
    public var fontFamily : String;
    public var underline : String;
    public var textColor : Color;
    public var weight : FontWeight;
    public var listLevelType : String;
    public var listBulletChar : String;


    public function setStyles(n : Node) {
        if(n instanceof Text) {
            (n as Text).fill = textColor;
            (n as Text).font = Font.font(fontFamily, weight, fontSize.getAsPixel());
        } else if(n instanceof Shape) {
            var s : Shape = n as Shape;
            s.fill = if(fillType != "none") fillColor else null;
            s.stroke = if(stroke != "none") strokeColor else null;
            s.opacity = opacity;
        }
    }
}
