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
import javafx.util.Sequences;


public def nsDRAW = "urn:oasis:names:tc:opendocument:xmlns:drawing:1.0";
public def nsOFFICE = "urn:oasis:names:tc:opendocument:xmlns:office:1.0";
public def nsSTYLE = "urn:oasis:names:tc:opendocument:xmlns:style:1.0";
public def nsFO = "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0";
public def nsDC = "http://purl.org/dc/elements/1.1/";
public def nsXLINK = "http://www.w3.org/1999/xlink";
public def nsSVG = "urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0";
public def nsTEXT = "urn:oasis:names:tc:opendocument:xmlns:text:1.0";
public def nsPRESENTATION = "urn:oasis:names:tc:opendocument:xmlns:presentation:1.0";
public def nsANIM = "urn:oasis:names:tc:opendocument:xmlns:animation:1.0";
public def nsCHART = "urn:oasis:names:tc:opendocument:xmlns:chart:1.0";
public def nsDOM = "urn:oasis:names:tc:opendocument:xmlns:chart:1.0";
public def nsDR3D = "urn:oasis:names:tc:opendocument:xmlns:chart:1.0";
public def nsFORM = "urn:oasis:names:tc:opendocument:xmlns:form:1.0";
public def nsMATH = "http://www.w3.org/1998/Math/MathML";
public def nsMETA = "urn:oasis:names:tc:opendocument:xmlns:meta:1.0";
public def nsNUMBER = "urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0";
public def nsSCRIPT = "urn:oasis:names:tc:opendocument:xmlns:script:1.0";
public def nsSMIL = "urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0";
public def nsTABLE = "urn:oasis:names:tc:opendocument:xmlns:table:1.0";

public abstract class PNode {

        public-read protected var children : PNode[] = [];
	public-read protected var parent : PNode = null;
        protected var prefix : String = bind parsePrefix(nodeName);
	protected var nsURI : String = null;
	protected var localName : String = bind parseName(nodeName);
        public-read protected var nodeName : String = "";
        public-read protected var doc : PDocument = null;

	public function getElementsByTagName(tagname : String) : PElement[] {
		var ret : PElement[] = [];
                if(tagname.equals(nodeName)) insert this as PElement into ret;
		for(node in children where node instanceof PElement) {
                        insert node.getElementsByTagName(tagname) into ret;
		}
		return ret;
	}

        public function getElementsByTagNameNS(uri : String, tagname : String) : PElement[] {
		var ret : PElement[] = [];
                if(localName.equals(tagname) and
                                    nsURI.equals(uri)) insert this as PElement into ret;
		for(node in children where node instanceof PElement) {
                        insert node.getElementsByTagNameNS(uri, tagname) into ret;
		}		
                return ret;
	}

	function getDescendants() : PNode[] {
		var l : PNode[];
                for(n in children) {
                    insert n into l;
                    insert n.getDescendants() into l;
                }
		return l;
	}

	protected function parsePrefix(name1 : String) : String {
		if(name1 == null) return null;
		if(name1.indexOf(":") == -1) return null;
		return name1.substring(0, name1.indexOf(":"));
	}

	protected function parseName(name1 : String) : String {
		if(name1 == null) return null;
		if(name1.indexOf(":") == -1) return name1;
		return name1.substring(name1.indexOf(":")+1);
	}

	public function appendChild(newChild : PNode) : Void {
                newChild.parent = this;
		insert newChild into children;
	}

	public function getTextContent() : String {
		/* TODO if(getNodeType() == Node.TEXT_NODE) return getNodeValue();
		String ret = "";
		Node n = getFirstChild();
		while(n != null) {
			ret += n.getTextContent();
			n = n.getNextSibling();
		}
		return ret;*/
                ""
        }

	public function normalize() : Void {
                for(n in children) {
                    n.normalize();
                }
	}

/*
	public void setTextContent(String textContent) throws DOMException {
		if(getNodeType() != ELEMENT_NODE) return;
		while(getFirstChild() != null) {
			removeChild(getFirstChild());
		}
		appendChild(getOwnerDocument().createTextNode(textContent));
	}
*/
	abstract public function serialize(level : Integer) : String;

	protected function indent(level : Integer) : String {
		var ret = "";
		for(i in [1..level]) {
			ret = "{ret}\t";
		}
		return ret;
	}

        public function getPreviousSibling() : PNode {
            var idx = Sequences.indexByIdentity(parent.children, this);
            if(idx == 0) return null;
            return parent.children[idx-1];
        }


/*	public PNode getNextInDocOrder(PNode end) {
		PNode next = null;
		// descend
		if(firstChild != null) return firstChild;
		if(this == end) return null;
		// next sibling
		next = (PNode) getNextSibling();
		if(next != null) return next;
		next = this;
		// parents sibling
		while(next.getNextSibling() == null) {
			next = next.parent;
			if(next == null) return null;
			if(next == end) return null;
		}
		return (PNode) next.getNextSibling();
	}*/
}
