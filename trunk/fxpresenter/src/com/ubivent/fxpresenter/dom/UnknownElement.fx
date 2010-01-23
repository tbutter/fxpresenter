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

package com.ubivent.fxpresenter.dom;
import java.util.HashSet;
import java.lang.System;
import javafx.util.Sequences;

public function print() {
    for(e in unknownElements) {
        System.out.println(e);
    }
}

var unknownElements : HashSet = new HashSet();

var ignoredElements : String[] = ["office:forms","meta:creation-date","office-styles","office-settings","office:scripts","dc:date","presentation:date-time","office:master-styles","dc:creator","office:document-settings","office:meta","office:automatic-styles","meta:user-defined","office:document-meta","style:handout-master","office:body","office:document-content","meta:editing-duration","config:config-item-set","config:config-item-map-indexed", "office:presentation", "meta:editing-cycles", "meta:document-statistic", "office:document", "meta:generator", "config:config-item-map-entry", "dc:title", "office:document-styles", "presentation:notes"];

public class UnknownElement extends PElement {
    postinit {
        if(Sequences.indexOf(ignoredElements,nodeName) == -1)
            unknownElements.add(nodeName);
    }

    override public function toString() : String {
        return "{nodeName} (unimplemented)";
    }

}
