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
import javafx.scene.Node;
import javafx.scene.shape.FillRule;
import javafx.scene.shape.Path;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import java.lang.String;
import java.util.StringTokenizer;
import javafx.scene.shape.ClosePath;
import javafx.scene.shape.MoveTo;
import javafx.scene.shape.LineTo;
import javafx.util.Math;
import javafx.scene.shape.ArcTo;
import javafx.geometry.Rectangle2D;
import com.ubivent.fxpresenter.graphics.Length;
import javafx.scene.transform.Scale;


public class EnhancedGeometry extends PElement, EquationContainer {
	postinit {
		nsURI = nsDRAW;
                nodeName = "draw:enhanced-geometry";
	}

	function createShape(map : StyleMap) : Path {
                var path : String = getAttributeNS(nsDRAW, "enhanced-path").value;
		if(path == null or path == "") {
			// XXX: DIRTY OO.o hack
			if(getAttributeNS(nsDRAW, "type").equals("ellipse")) {
				path = "M 0 10800 Y 10800 0 21600 10800 10800 21600 0 10800 Z N";
			}
			//return ret;
		}
                var ret : Path = Path { id: path fillRule : FillRule.EVEN_ODD };
		map.setStyles(ret);
                var st = new StringTokenizer(path);
		var token : String = null;
		var currentcommand : String = null;
		var state : Integer = 0;
		var x : Double = 0;
		var y : Double = 0;
                var x2 : Double = 0;
		var y2 : Double = 0;
                var x3 : Double = 0;
		var y3 : Double = 0;
                var x4 : Double = 0;
		var y4 : Double = 0;
		var startdegree : Double = 0;
		var extend : Double = 0;
                var curx : Double = 0;
                var cury : Double = 0;
		while((token != null and token != "") or st.hasMoreElements()) {
			while(token == null or token == "") token = st.nextToken();
			if(token.equals("M") or token.equals("L") or token.equals("X") or token.equals("Y") or token.equals("W")) { // TODO fix X and Y
				currentcommand = token;
				//if(currentcommand.equals("X") || currentcommand.equals("Y")) currentcommand = "L";
				state = 0;
			} else if(token.equals("Z")) {
				insert ClosePath {} into ret.elements;
			} else if(token.equals("N")) {
				// what is the difference to "Z"?
			} else { // TODO add more path commands
				if(currentcommand.equals("M")) {
					if(state == 0) x = parseNumber(token);
					if(state == 1) y = parseNumber(token);
					state++;
					if(state == 2) {
                                                curx = x;
                                                cury = y;
                                                insert MoveTo { x: x y: y } into ret.elements;
                                                state = 0;
					}
				} else if(currentcommand.equals("L")) {
					if(state == 0) x = parseNumber(token);
					if(state == 1) y = parseNumber(token);
					state++;
					if(state == 2) {
                                                curx = x;
                                                cury = y;
						insert LineTo { x: x y: y} into ret.elements;
						state = 0;
					}
				} else if(currentcommand.equals("W")) {
                                        if(state == 0) x = parseNumber(token);
					if(state == 1) y = parseNumber(token);
                                        if(state == 2) x2 = parseNumber(token);
					if(state == 3) y2 = parseNumber(token);
                                        if(state == 4) x3 = parseNumber(token);
					if(state == 5) y3 = parseNumber(token);
                                        if(state == 6) x4 = parseNumber(token);
					if(state == 7) y4 = parseNumber(token);
					state++;
                                        if(state == 8) {
                                            insert MoveTo {
                                                x: x3
                                                y: y3
                                            } into ret.elements;
                                            insert ArcTo {
                                                x: x4
                                                y: y4
                                                radiusX: (x2 - x)/2.0
                                                radiusY: (y2 - y)/2.0
                                                sweepFlag: true
                                                largeArcFlag: true
                                            } into ret.elements;
                                            state = 0;
                                        }
                                } else if(currentcommand.equals("Y")) {
					if(state mod 2 == 0) x = parseNumber(token);
					if(state mod 2 == 1) y = parseNumber(token);
					state++;
					if(state == 2) {
                                                if(sizeof ret.elements == 0) insert MoveTo { x : x y : y } into ret.elements;
						if(curx < x) {
							if(cury < y) {
								startdegree = 180;
								extend = 90;
							} else { // OK
								startdegree = 180;
								extend = -90;
							}
						} else {
							if(cury < y) {
								startdegree = 0;
								extend = -90;
							} else {
								startdegree = 0;
								extend = 90;
							}
						}
					}
					if(state mod 2 == 0) { 
						var rx = if(curx>x)  x else curx;
						var ry = if(cury>y)  y else cury;
						if(startdegree==270 or startdegree==90) {
							rx -= Math.abs(curx-x);
						}
						if(startdegree==0) {
							rx -= Math.abs(curx-x);
							ry -= Math.abs(cury-y);
						}
						if(extend==90 or startdegree==-90) {
							ry -= Math.abs(cury-y);
						}
                                                var w = Math.abs(curx-x);
                                                var h = Math.abs(cury-y);
						var arc = ArcTo {
                                                        x: x
                                                        y: y
                                                        radiusX: w
                                                        radiusY: h
                                                        xAxisRotation: startdegree
                                                        //length: extend
                                                         };
						insert arc into ret.elements;
						//System.out.println("start"+arc.getStartPoint()+" end"+arc.getEndPoint()+" startdegree"+startdegree+" extend"+extend);
						startdegree += extend;
						//ret.lineTo((float)x,(float)y);
						//state = 0;
					}
				}
				else println("Missing path command: {currentcommand}");
			}
			token = null;
		}
		return ret;
	}

	override public function getModifier(index : Integer) : Double {
		var modifiers : String = getAttributeNS(nsDRAW, "modifiers").value;
		var st : StringTokenizer = new StringTokenizer(modifiers);
		var i = 0;
		while(st.hasMoreTokens()) {
			var token = st.nextToken();
			if(i == index) return parseNumber(token);
			i++;
		}
		return 0;
	}

	override public function getEquation(name : String) : Equation {
		for(n in children) {
			if(n instanceof Equation) {
				var equation = n as Equation;
				if(equation.getEquationName().equals(name)) return equation;
			}
		}
                println("could not find equation {name}");
		return null;
	}

	override public function parseNumber(token : String) : Double {
		if(token.startsWith("$")) return getModifier(Integer.parseInt(token.substring(1)));
		if(token.startsWith("?")) {
			var equationName = token.substring(1);
			var equation = getEquation(equationName);
			return equation.calc();
		}
		return Double.parseDouble(token);
	}

	override public function getEquationVariable(name : String) : Double {
                if(name.equals("pi")) return Math.PI;
		var viewbox = getViewBox();
		if(name.equals("left")) return viewbox.minX;
		if(name.equals("top")) return viewbox.minY;
		if(name.equals("right")) return viewbox.maxX;
		if(name.equals("bottom")) return viewbox.maxY;
		if(name.equals("width")) return viewbox.width;
		if(name.equals("height")) return viewbox.height;
		println("Unknown variable name in EnhancedGeometry.getEquationVariable({name})");
		return 0;
	}

	public function getViewBox() : Rectangle2D {
		var s : String = getAttributeNS(nsSVG, "viewBox").value;
		var st = new StringTokenizer(s);
		var x = Double.parseDouble(st.nextToken());
		var y = Double.parseDouble(st.nextToken());
		var w = Double.parseDouble(st.nextToken());
		var h = Double.parseDouble(st.nextToken());
		return Rectangle2D { minX: x minY: y width: w height: h };
	}

	public function createNode(map : StyleMap, wo : Length, ho : Length) : Node[] {
		var s = createShape(map);
		var r = getViewBox();
		var w = wo.getAsPixel();
		var h = ho.getAsPixel();
                s.transforms = Scale {
                    pivotX: r.minX
                    pivotY: r.minY
                    x: w / r.width
                    y: h / r.height
                }
                /*for(pe in s.elements) {
                    if(pe instanceof MoveTo) println("MoveTo {(pe as MoveTo).x} {(pe as MoveTo).y}");
                    if(pe instanceof LineTo) println("LineTo {(pe as LineTo).x} {(pe as LineTo).y}");
                    if(pe instanceof ArcTo) println("ArcTo {(pe as ArcTo).x} {(pe as ArcTo).y} {(pe as ArcTo).radiusX} {(pe as ArcTo).radiusY} {(pe as ArcTo).xAxisRotation}");
                    if(pe instanceof ClosePath) println("ClosePath");
                }*/
                return s;
	}
}
