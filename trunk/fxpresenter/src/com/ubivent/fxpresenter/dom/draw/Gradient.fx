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
import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.dom.style.StyleProperties;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.paint.Color;


public class Gradient extends PElement, StyleProperties {
        postinit {
                //println("inited gradient {getStyleName()}");
                nsURI = nsDRAW;
                nodeName = "draw:gradient";
	}


	override public function addToStyleMap(map : StyleMap, level : Integer) {
                println("FOUND A GRADIENT");
                // TODO
                map.fillColor = LinearGradient {
                    startX: 0
                    startY: 0
                    endX: 1
                    endY: 1
                    proportional: true
                    stops: [
                            Stop {
                                color: Color.BLUE
                                offset:0
                            }
                            Stop {
                                color: Color.ORANGE
                                offset: 1
                            }
                            ]
                };
	}
}
