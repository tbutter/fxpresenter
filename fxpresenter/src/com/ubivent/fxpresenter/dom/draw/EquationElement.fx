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

import javafx.util.Math;



public def NUMBER = 1;
public def IDENTIFIER = 2;
public def FUNCTION = 3;
public def ADDITION = 4;
public def SUBSTRACTION = 5;
public def MULTIPLICATION = 6;
public def DIVISION = 7;
public def FUNCTIONREFERENCE = 8;
public def MODIFIERREFERENCE = 9;

public class EquationElement {
        public var type : Integer;
        public var value : String;
        public var children : EquationElement[] = [];
        public-init var equation : Equation;

        public function evaluate() : Double {
                if(type == NUMBER)
                        return Double.parseDouble(value);
                if(type == IDENTIFIER)
                        return (equation.parent as EquationContainer).getEquationVariable(value);
                if(type == FUNCTION) {
                        if(value.equals("abs")) {
                                return Math.abs(children[0].evaluate());
                        } else if(value.equals("sqrt")) {
                                return Math.sqrt(children[0].evaluate());
                        } else if(value.equals("sin")) {
                                return Math.sin(children[0].evaluate());
                        } else if(value.equals("cos")) {
                                return Math.cos(children[0].evaluate());
                        } else if(value.equals("tan")) {
                                return Math.tan(children[0].evaluate());
                        } else if(value.equals("atan")) {
                                return Math.atan(children[0].evaluate());
                        } else if(value.equals("atan2")) {
                                return Math.atan2(children[0].evaluate(), children[1].evaluate());
                        } else if(value.equals("min")) {
                                return Math.min(children[0].evaluate(), children[1].evaluate());
                        } else if(value.equals("max")) {
                                return Math.max(children[0].evaluate(), children[1].evaluate());
                        } else if(value.equals("if")) {
                                if(children[0].evaluate() != 0) {
                                        return children[1].evaluate();
                                } // else
                                return children[2].evaluate();
                        }
                        println("error unknown function {value}");
                }
                if(type == ADDITION)
                        return children[0].evaluate() + children[1].evaluate();
                if(type == SUBSTRACTION)
                        return children[0].evaluate() - children[1].evaluate();
                if(type == MULTIPLICATION)
                        return children[0].evaluate() * children[1].evaluate();
                if(type == DIVISION)
                        return children[0].evaluate() / children[1].evaluate();
                if(type == FUNCTIONREFERENCE)
                        return (equation.parent as EquationContainer).getEquation(value).calc();
                if(type == MODIFIERREFERENCE)
                        return (equation.parent as EquationContainer).getModifier(Integer.parseInt(value));
                return 0;
        }

        override public function toString() : String {
                var s : String = "[{type},{value}";
                for(child in children) {
                    s = "{s} {child.toString()}";
                }
                return "{s}]";
        }
}
