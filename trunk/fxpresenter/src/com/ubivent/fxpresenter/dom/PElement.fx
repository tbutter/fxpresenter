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

import java.lang.String;

public class PElement extends PNode {

        public var attributes : PAttr[] = [];

	public function getAttribute(namel : String) : PAttr {
                for(attr in attributes) {
                    if(namel.equals(attr.nodeName)) return attr;
                }
                return null;
	}

        public function getAttributeLocal(namel : String) : PAttr {
                for(attr in attributes) {
                    if(namel.equals(attr.localName)) return attr;
                }
                return null;
	}

        public function getAttributeNS(uri : String, namel : String) : PAttr {
                for(attr in attributes) {
                    if(namel.equals(attr.localName) and uri.equals(attr.nsURI)) return attr;
                }
                return null;
	}

        public function docOrderChildren() : PNode[] {
            var ret : PNode[] = [];
            for(n in children) {
                insert n into ret;
                if(n instanceof PElement) {
                    insert (n as PElement).docOrderChildren() into ret;
                }
            }
            ret;
        }


	override public function serialize(level : Integer) : String {
		var ret = "{indent(level)}<{nodeName}";
		for(attr in attributes) {
			ret = "{ret} {attr.serialize(level)}";
		}
		ret = "{ret}>\n";
		for(node in children) {
                    ret = "{ret}node.serialize(level+1)";
		}
		ret = "{ret}{indent(level)}</{nodeName}>\n";
		return ret;
	}
}
