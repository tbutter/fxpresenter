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
import com.ubivent.fxpresenter.dom.style.MasterPage;
import java.io.ByteArrayInputStream;
import java.lang.String;
import java.util.HashMap;
import java.io.IOException;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;
import java.io.File;
import java.util.zip.ZipEntry;
import com.ubivent.fxpresenter.dom.PDocument;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import javafx.data.pull.Event;
import javafx.data.pull.PullParser;
import java.util.Stack;
import com.ubivent.fxpresenter.dom.style.Style;
import javafx.data.xml.QName;
import com.ubivent.fxpresenter.dom.draw.TextBox;
import com.ubivent.fxpresenter.dom.draw.Page;
import com.ubivent.fxpresenter.dom.text.ListItem;
import com.ubivent.fxpresenter.dom.text.Paragraph;
import com.ubivent.fxpresenter.dom.text.Span;
import com.ubivent.fxpresenter.dom.text.TextList;
import com.ubivent.fxpresenter.dom.style.PageLayout;
import com.ubivent.fxpresenter.dom.style.PageLayoutProperties;
import com.ubivent.fxpresenter.dom.style.GraphicProperties;
import com.ubivent.fxpresenter.dom.style.ListLevelProperties;
import com.ubivent.fxpresenter.dom.style.DefaultStyle;
import com.ubivent.fxpresenter.dom.style.DrawingPageProperties;
import com.ubivent.fxpresenter.dom.style.ParagraphProperties;
import com.ubivent.fxpresenter.dom.style.TextProperties;
import com.ubivent.fxpresenter.dom.draw.Frame;
import com.ubivent.fxpresenter.dom.draw.CustomShape;
import com.ubivent.fxpresenter.dom.draw.DImage;
import com.ubivent.fxpresenter.dom.draw.EnhancedGeometry;
import com.ubivent.fxpresenter.dom.draw.Equation;
import com.ubivent.fxpresenter.dom.text.ListLevelStyleBullet;
import com.ubivent.fxpresenter.dom.text.ListStyle;
import com.ubivent.fxpresenter.dom.draw.DrawGroup;
import com.ubivent.fxpresenter.dom.draw.Rect;
import com.ubivent.fxpresenter.dom.draw.Gradient;

/**
 * @author thomasbutter
 */

public class PDocument extends PNode {
        public var docuri : String;

	public function getPages() : Page[] {
	    var ret = getElementsByTagNameNS(nsDRAW, "page") as Page[];
            println("found {sizeof ret} pages");
            return ret;
	}

	public function getStyle(name : String, family : String, n : PNode ) : Style {
                var node = n;
		// try first 'nearby' style. do not know why - not stated in standard
		while ((not node.localName.equals("document-styles"))
				and (not node.localName.equals("document-content"))) {
			node = node.parent;
		}
		var list : PElement[];
		if (family.equals("list")) {
			list = (node as PElement).getElementsByTagNameNS(nsTEXT,
					"list-style");
		} else {
			list = (node as PElement).getElementsByTagNameNS(nsSTYLE, "style");
		}
                for(l in list) if(not(l instanceof Style)) {
                        println("unimplemented style {l.nodeName}");
                        delete l from list;
                }
                var slist = list as Style[];
                for(mp in slist) {
                    if (mp.getStyleName() != null and mp.getStyleName().equals(name)
                                    and mp.getFamily() != null and mp.getFamily().equals(family))
                        return mp;
		}
		// now try whole document
		if (family.equals("list")) {
			list = getElementsByTagNameNS(nsTEXT, "list-style");
		} else {
			list = getElementsByTagNameNS(nsSTYLE, "style");
		}
                for(l in list) if(not(l instanceof Style)) {
                        delete l from list;
                }
                slist = list as Style[];
		for (mp in slist) {
			if (mp.getStyleName().equals(name) and mp.getFamily() != null
					and mp.getFamily().equals(family))
				return mp;
		}
		return null;
	}

	public function getDefaultStyle(family : String, n : PNode) : Style {
                var node = n;
		// try first 'nearby' style. do not know why - not stated in standard
		while((not node.localName.equals("document-styles")) and not node.localName.equals("document-content")) {
			node = node.parent;
		}
		var list = (node as PElement).getElementsByTagNameNS(nsSTYLE, "default-style") as Style[];
		for(mp in list) {
			if(mp.getAttribute("style:family") != null and
					mp.getAttribute("style:family").equals(family))
				return mp;
		}
		// now try whole document
		list = getElementsByTagNameNS(nsSTYLE, "default-style") as Style[];
		for(mp in list) {
			if(mp.getAttribute("style:family") != null and
					mp.getAttribute("style:family").equals(family))
				return mp;
		}
		return null;
	}

	public function getMasterPage(name : String) : MasterPage {
            // TODO find the right one
            var masterPages = getElementsByTagNameNS(nsSTYLE, "master-page");
            for(mp in masterPages) {
                if(mp.getAttribute("style:name").value == name) return mp as MasterPage;
            }
            return null;
	}

	public function getElementWithAttribute(nsuri : String, name : String, attribname : String, value : String) : PElement {
		var list = getElementsByTagNameNS(nsuri, name);
		for(mp in list) {
                    if(mp.getAttribute(attribname).value.equals(value))
                        return mp;
		}
		return null;
	}

        public function createAttribute(name1 : String) : PAttr {
		var pattr = PAttr { doc: this nodeName: name1};
		pattr.doc = this;
		return pattr;
	}

	public function createAttributeNS(namespaceURI : String, qualifiedName : String) : PAttr {
		var pattr = PAttr { doc: this nsURI: namespaceURI nodeName: qualifiedName };
		return pattr;
	}

	public function createCDATASection(data : String) : PCDataSection {
		var cdata = PCDataSection{ doc: this data: data };
		return cdata;
	}

	public function createComment(data : String) : PComment {
		var comment = PComment { doc: this data: data};
		return comment;
	}

	public function createElementNS(namespaceURI : String, qualifiedName : String) : PElement{
                var ret : PElement = null;
		if(namespaceURI.equals(nsDC)) {
//			return new DCTag(this, namespaceURI, qualifiedName);
		}
		if(namespaceURI.equals(nsDRAW)) {
                        if(parseName(qualifiedName).equals("gradient")) {
                            ret = Gradient{};
                        }
/*			if(parseName(qualifiedName).equals("polyline"))
				return new Polyline(this);
			if(parseName(qualifiedName).equals("line"))
				return new Line(this);
			if(parseName(qualifiedName).equals("connector"))
				return new Connector(this);*/
			if(parseName(qualifiedName).equals("g"))
				ret = DrawGroup{};
			if(parseName(qualifiedName).equals("page"))
				ret = Page {};
			if(parseName(qualifiedName).equals("text-box"))
				ret = TextBox {};
			if(parseName(qualifiedName).equals("image"))
				ret = DImage{};
			if(parseName(qualifiedName).equals("frame"))
				ret = Frame{};
			if(parseName(qualifiedName).equals("enhanced-geometry"))
				ret = EnhancedGeometry{};
			if(parseName(qualifiedName).equals("custom-shape"))
				ret = CustomShape{};
			if(parseName(qualifiedName).equals("rect"))
				ret = Rect{};
			if(parseName(qualifiedName).equals("equation"))
				ret = Equation{};
		}
		if(namespaceURI.equals(nsTEXT)) {
			if(parseName(qualifiedName).equals("p"))
				ret = Paragraph{};/*
			if(parseName(qualifiedName).equals("page-number"))
				return new PageNumber(this);*/
			if(parseName(qualifiedName).equals("span"))
				ret = Span{};
			if(parseName(qualifiedName).equals("list"))
				ret = TextList{};
			if(parseName(qualifiedName).equals("list-item"))
				ret = ListItem{};
			if(parseName(qualifiedName).equals("list-style"))
				ret = ListStyle{};
			if(parseName(qualifiedName).equals("list-level-style-bullet"))
				ret = ListLevelStyleBullet{};/*
			if(parseName(qualifiedName).equals("line-break"))
				return new LineBreak(this);
			if(parseName(qualifiedName).equals("s"))
				return new Space(this);
			if(parseName(qualifiedName).equals("tab"))
				return new Tab(this);*/
		}
		if(namespaceURI.equals(nsSTYLE)) {
			if(parseName(qualifiedName).equals("master-page"))
				ret = MasterPage{};
			if(parseName(qualifiedName).equals("page-layout"))
				ret = PageLayout{};
			if(parseName(qualifiedName).equals("page-layout-properties"))
				ret = PageLayoutProperties{};
			if(parseName(qualifiedName).equals("style"))
				ret = Style{};
			if(parseName(qualifiedName).equals("default-style"))
				ret = DefaultStyle{};
			if(parseName(qualifiedName).equals("graphic-properties"))
				ret = GraphicProperties{};
			if(parseName(qualifiedName).equals("paragraph-properties"))
				ret = ParagraphProperties{};
			if(parseName(qualifiedName).equals("text-properties"))
				ret = TextProperties{};
			if(parseName(qualifiedName).equals("drawing-page-properties"))
				ret = DrawingPageProperties{};
			if(parseName(qualifiedName).equals("list-level-properties"))
				ret = ListLevelProperties{};
		}
		// fallback
                if(ret == null) {
                    var elem = UnknownElement { doc: this nsURI: namespaceURI nodeName: qualifiedName };
                    return elem;
                }
                ret.doc = this;
                return ret;
	}

	public function createTextNode(data : String) : PText {
            var text = PText { doc: this data: data };
            return text;
	}

	override public function serialize(level : Integer) : String{
		return children[0].serialize(0);
	}

	var files : HashMap = null;

	public function getFileAsStream(filenamea : String) : InputStream {
		var filename = filenamea;
                if(filename.startsWith("./")) filename = filename.substring(2);
		if(files != null) {
			if(not files.containsKey(filename)) return null;
			return new ByteArrayInputStream(ByteArrayCaster.castToByteArray(files.get(filename)));
		}
		if(inputfile != null) {
			return inputfile.getInputStream(inputfile.getEntry(filename));
		}
		return null;
	}

	var inputfile : ZipFile = null;

	public function setInputFile(f : File) : Void  {
		if(files != null) throw new IOException("Two input files!");
		inputfile = new ZipFile(f);
	}

	public function setInputStream(is : InputStream) {
            if(inputfile != null) throw new IOException("Two input files!");
            files = new HashMap();
            var zis = new ZipInputStream(is);
            var ze : ZipEntry = null;
            while((ze = zis.getNextEntry()) != null) {
                if(not ze.isDirectory()) {
                    var size = ze.getSize();
                    var boas = new ByteArrayOutputStream();
                    var b : Integer;
                    while((b = zis.read()) != -1) {
                        boas.write(b);
                    }
                    files.put(ze.getName(), boas.toByteArray());
                }
            }
	}
        /*

	private void addXMLNS(Element elem) {
		elem.setAttribute("xmlns:anim", nsANIM);
		elem.setAttribute("xmlns:chart", nsCHART);
		elem.setAttribute("xmlns:dc", nsDC);
		elem.setAttribute("xmlns:dom", nsDOM);
		elem.setAttribute("xmlns:dr3d", nsDR3D);
		elem.setAttribute("xmlns:draw", nsDRAW);
		elem.setAttribute("xmlns:fo", nsFO);
		elem.setAttribute("xmlns:form", nsFORM);
		elem.setAttribute("xmlns:math", nsMATH);
		elem.setAttribute("xmlns:meta", nsMETA);
		elem.setAttribute("xmlns:number", nsNUMBER);
		elem.setAttribute("xmlns:office", nsOFFICE);
		elem.setAttribute("xmlns:presentation", nsPRESENTATION);
		elem.setAttribute("xmlns:script", nsSCRIPT);
		elem.setAttribute("xmlns:smil", nsSMIL);
		elem.setAttribute("xmlns:style", nsSTYLE);
		elem.setAttribute("xmlns:svg", nsSVG);
		elem.setAttribute("xmlns:table", nsTABLE);
		elem.setAttribute("xmlns:text", nsTEXT);
		elem.setAttribute("xmlns:xlink", nsXLINK);
		elem.setAttribute("office:version", "1.0");
	}

	public static PDocument createEmptyDocument() {
		PDocument doc = new PDocument();
		Element document = doc.createElementNS(nsOFFICE, "office:document");
		doc.appendChild(document);
		Element documentContent = doc.createElementNS(nsOFFICE, "office:document-content");
		doc.addXMLNS(documentContent);
		document.appendChild(documentContent);
		Element documentStyles = doc.createElementNS(nsOFFICE, "office:document-styles");
		doc.addXMLNS(documentStyles);
		document.appendChild(documentStyles);
		Element documentMeta = doc.createElementNS(nsOFFICE, "office:document-meta");
		doc.addXMLNS(documentMeta);
		document.appendChild(documentMeta);
		Element documentSettings = doc.createElementNS(nsOFFICE, "office:document-settings");
		doc.addXMLNS(documentSettings);
		document.appendChild(documentSettings);
		Element officeStyles = doc.createElementNS(nsOFFICE, "office:styles");
		documentStyles.appendChild(officeStyles);
		Element officeAutomaticStyles = doc.createElementNS(nsOFFICE, "office:automatic-styles");
		documentStyles.appendChild(officeAutomaticStyles);
		Element officeDocumentAutomaticStyles = doc.createElementNS(nsOFFICE, "office:automatic-styles");
		documentContent.appendChild(officeDocumentAutomaticStyles);
		Element masterStyles = doc.createElementNS(nsOFFICE, "office:master-styles");
		documentStyles.appendChild(masterStyles);
		return doc;
	}*/

}

public function createFromODP(f : File) : PDocument {
        var pdoc = new PDocument();
        pdoc.setInputFile(f);
        internalCreateFromODP(pdoc);
        return pdoc;
}

public function createFromODP(f : InputStream) : PDocument {
        var pdoc = new PDocument();
        pdoc.setInputStream(f);
        internalCreateFromODP(pdoc);
        return pdoc;
}

function internalCreateFromODP(pdoc : PDocument) : Void {
    var rootelem = pdoc.createElementNS(PNode.nsOFFICE,
                             "office:document");

    pdoc.children = rootelem;
    var stack : Stack = new Stack();
    stack.push(rootelem);

    PullParser {
        documentType: PullParser.XML;
        input: pdoc.getFileAsStream("styles.xml")
        onEvent: function(event: Event) {
            processEvent(event, stack, pdoc);
        }
    }.parse();

    PullParser {
        documentType: PullParser.XML;
        input: pdoc.getFileAsStream("content.xml")
        onEvent: function(event: Event) {
            processEvent(event, stack, pdoc);
        }
    }.parse();

    PullParser {
        documentType: PullParser.XML;
        input: pdoc.getFileAsStream("meta.xml")
        onEvent: function(event: Event) {
            processEvent(event, stack, pdoc);
        }
    }.parse();

    PullParser {
        documentType: PullParser.XML;
        input: pdoc.getFileAsStream("settings.xml")
        onEvent: function(event: Event) {
            processEvent(event, stack, pdoc);
        }
    }.parse();
}

function processEvent(event : Event, stack : Stack, pdoc : PDocument) : Void {
    if (event.type == PullParser.START_ELEMENT) {
        var name = event.qname.name;
        if(event.qname.prefix != "") name = "{event.qname.prefix}:{name}";
        var lElement = pdoc.createElementNS(event.qname.namespace, name); // TODO check name

        // copy attributes
        var aNames : QName[] = event.getAttributeNames();
        for(aName in aNames) {
            name = aName.name;
            if(aName.prefix != "") name = "{aName.prefix}:{name}";
            var lAttr = pdoc.createAttributeNS(aName.namespace, name);
            lAttr.value = event.getAttributeValue(aName);
            insert lAttr into lElement.attributes;
        }

        // append the element
        var par = stack.peek() as PElement;
        par.appendChild(lElement);
        stack.push(lElement);

    } else if (event.type == PullParser.END_ELEMENT) {
        stack.pop();
    } else if (event.type == PullParser.TEXT or event.type == PullParser.CDATA) {
        (stack.peek() as PElement).appendChild(pdoc.createTextNode(event.text));
    }
}