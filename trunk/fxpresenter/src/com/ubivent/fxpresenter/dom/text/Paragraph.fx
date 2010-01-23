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
package com.ubivent.fxpresenter.dom.text;

import com.ubivent.fxpresenter.dom.PElement;
import com.ubivent.fxpresenter.dom.style.StyleMap;
import com.ubivent.fxpresenter.graphics.Length;
import com.ubivent.fxpresenter.dom.PText;
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.draw.DShape;
import com.ubivent.fxpresenter.dom.draw.Page;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.dom.text.TextUtil;
import javafx.scene.text.Text;
import javafx.scene.Group;
import javafx.scene.text.TextAlignment;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;


public class Paragraph extends PElement, StyledElement {
        postinit {
		nsURI = nsTEXT;
                nodeName = "text:p";
	}

        var group : Group;
        var line : Text[] = [];
        var yOffset : Double = 0;
        var align : TextAlignment = TextAlignment.LEFT;
        var w : Double = 0;
        var left : Double = 0;
        var txt : String = "";
        public-read var firstBaseline : Number = 0;

        public function createNode(map : StyleMap, width : Length, height : Length) {
            firstBaseline = 0;
            w = width.getAsPixel();
            var h = height.getAsPixel();
            var docOrder = docOrderChildren();
            group = Group {};
            line = [];
            yOffset = 0;
            TextUtil.styleToStyleMap(map, getStyleList(), this);
            align = map.textAlign;
            left = 0;
            for(n in docOrder) {
                    var skipContent = false;
                    if(n instanceof PText /* TODO or node instanceof TextEquivalent*/) {
                        var par = n.parent;
                        while(par != null and not(par instanceof StyledElement)) {
                            par = par.parent;
                        }
                        if(par instanceof StyledElement) {
                            var styles = (par as StyledElement).getStyleList();
                            TextUtil.styleToStyleMap(map, styles, par);
                            align = map.textAlign;
                        }
                        if(n instanceof PText) {
                            txt = (n as PText).data.trim();
                        } else if(n.nodeName == "text:line-break") {
                            txt = "\n";
                        }
                        // TODO TextEquivalent / PageNumber
                        while(txt != "") {
                            while(txt.indexOf("  ") != -1) txt = txt.replaceAll("  ", " ");
                            if(txt.startsWith("\n") or (sizeof line > 0 and w - left < 10)) {
                                txt = txt.substring(1);
                                if(sizeof line > 0) advanceLine()
                                else yOffset += map.fontSize.getAsPixel();
                            } else {
                                var current = txt;//.trim();
                                txt = "";
                                if(current.indexOf("\n") != -1) {
                                    txt = current.substring(current.indexOf("\n"));
                                    current = current.substring(0, current.indexOf("\n"));
                                }
                                var mt : Text = Text {
                                    content: current
                                    // TODO 1.3 boundsType: TextBoundsType.LOGICAL
                                };
                                map.setStyles(mt);
                                var dontadd = false;
                                var useAnyway = false;
                                while(not useAnyway and not dontadd and mt.layoutBounds.width + left > w) {
                                    var idx = current.lastIndexOf(" ");
                                    //println("too long {current} {sizeof line} {idx} {left} {w} {mt.layoutBounds.width}");
                                    if(idx > 0) {
                                        txt = current.substring(idx).concat(" ").concat(txt);
                                        current = current.substring(0, idx);
                                    } else {
                                        if(sizeof line > 0) {
                                            txt = current.concat(" ").concat(txt);
                                            current = "";
                                            dontadd = true;
                                        } else {
                                            useAnyway = true;
                                        }

                                    }
                                    mt.content = current;
                                }
                                if(not dontadd) {
                                        mt.layoutX = left;
                                        insert mt into line;
                                        left += mt.layoutBounds.width;
                                } else {
                                    advanceLine();
                                }

                            }
                        }
                    }
            }
            advanceLine();
            if(sizeof group.content == 0)
                insert Rectangle { x: 0 y: 0 height: map.fontSize.getAsPixel() width: 1 fill: Color.color(0,0,0,0) stroke: null } into group.content;
            group;
        }

        function advanceLine() {
            if(sizeof line == 0) return;
            var offset = 0.0;
            var width = 0.0;
            var height = 0.0;
            var xOffset = 0.0;
            for(n in line) {
                if(offset < - n.layoutBounds.minY) offset = -n.layoutBounds.minY;
                width += n.layoutBounds.width;
                if(height < n.layoutBounds.height) height = n.layoutBounds.height;
            }
            if(firstBaseline == 0) firstBaseline = offset;
            if(align == TextAlignment.RIGHT) xOffset = w - width;
            if(align == TextAlignment.CENTER) xOffset = (w - width) / 2.0;
            for(n in line) {
                n.layoutY = offset + yOffset;
                n.layoutX += xOffset;
                insert n into group.content;
            }
            if(xOffset > 0) { // hack to make it fit if in VBox
                insert Line { stroke: null layoutX: 0 layoutY: yOffset - 1 } into group.content;
            }
            line = [];
            yOffset += height;
            left = 0;
            while(txt.startsWith(" ")) txt = txt.substring(1);
        }


/* TODO
	public AttributedCharacterIterator getAttributedIterator(double dpi, int pagenumber) {
		StringBuffer sb = new StringBuffer();
		PNode node = this;
		LinkedList<MapRange> maps = new LinkedList<MapRange>();
		while((node = node.getNextInDocOrder(this)) != null) {
			boolean jumpovercontent = false;
			if(node instanceof PText || node instanceof TextEquivalent) {
				Node parent1 = node.getParentNode();
				String text = "";
				if(!(parent1 instanceof StyledElement)) {
					parent1 = parent1.getParentNode();
				}
				if(parent1 instanceof StyledElement) {
					MapRange range = new MapRange();
					range.start = sb.length();
					if(node instanceof PText) {
						text = node.getNodeValue();
					} else if(node instanceof PageNumber) {
						text = ((PageNumber)node).getNumber(pagenumber);
						jumpovercontent = true;
					} else if(node instanceof TextEquivalent) {
						text = ((TextEquivalent)node).getTextEquivalent();
					}
					range.end = range.start + text.length();
					List<Style> styles = ((StyledElement)parent1).getStyleList();
					Map<StyleKey, Object> map = TextUtil.styleToStyleMap(styles, (PNode)parent1);
					range.map = TextUtil.getAttributeMap(map,dpi);
					/*System.out.println("Text: "+text+"\nStyles: ");
					for(Style s : styles) {
						System.out.println(" "+s.getStyleName()+" ["+s.getFamily()+"]");
					}*/
	/*				maps.add(range);
				}
				sb.append(text);
				if(jumpovercontent) {
					if(node.getLastChild() != null)
						node = (PNode)node.getLastChild();
				}
			}
		}
		if(sb.length()>0) {
			AttributedString as = new AttributedString(sb.toString());
			as.addAttribute(TextAttribute.SIZE, 10.0f);
			for(MapRange range : maps) {
				as.addAttributes(range.map, range.start, range.end);
			}
			return as.getIterator();
		}
		AttributedString as = new AttributedString(" ");
		Map<StyleKey, Object> map = TextUtil.styleToStyleMap(getStyleList(), this);
		as.addAttributes(TextUtil.getAttributeMap(map,dpi), 0, 1);
		return as.getIterator();
	}*/
/*
	class MapRange {
		int start;
		int end;
		Map<TextAttribute,Object> map;
	}
*/
	public override function getStyleList() : Style[] {
		var pnode = parent as StyledElement;
		while((not(pnode instanceof Page)) and (not(pnode instanceof DShape))) pnode = (pnode as PElement).parent as StyledElement;
		var ret = pnode.getStyleList();
		insert TextUtil.getStyleList(this, nsTEXT, "style-name", "paragraph") into ret;
		return ret;
	}
/*
	public DrawStringResult draw(JodGraphics g, Length xin, Length yin,
			Length widthin, Length heightin, Length fLOff, boolean draw) {
		Length x = xin.copy();
		Length y = yin.copy();
		Length width = widthin.copy();
		Length height = heightin.copy();

		DrawStringResult drawRes = null;
		AttributedCharacterIterator aci = getAttributedIterator(g.getDPI(), g.getPageNumber());
		if (aci != null) {
			Map<StyleKey, Object> map = TextUtil.styleToStyleMap(getStyleList(), this);
			/*if(map.get(StyleKey.MARGIN_LEFT) != null) {
				x.add((Length)map.get(StyleKey.MARGIN_LEFT));
				width.minus((Length)map.get(StyleKey.MARGIN_LEFT));
			}
			if(map.get(StyleKey.MARGIN_RIGHT) != null) {
				width.minus((Length)map.get(StyleKey.MARGIN_RIGHT));
			}
			if(map.get(StyleKey.MARGIN_TOP) != null) {
				y.add((Length)map.get(StyleKey.MARGIN_TOP));
				height.minus((Length)map.get(StyleKey.MARGIN_TOP));
			}
			if(map.get(StyleKey.MARGIN_BOTTOM) != null) {
				height.minus((Length)map.get(StyleKey.MARGIN_BOTTOM));
			}*/
/*			Length firstLineOffset = (Length)map.get(StyleKey.TEXTINDENT);
			if(firstLineOffset == null) firstLineOffset = new Length("0cm");
			if(fLOff != null) firstLineOffset = fLOff;
			drawRes = g
						.drawString(
								aci,
								x,
								y,
								width,
								height,
								map.containsKey(StyleKey.TEXTALIGN) ? (StyleKey.Align) map
										.get(StyleKey.TEXTALIGN)
										: StyleKey.Align.LEFT, firstLineOffset,draw);
		}
		if(drawRes == null) {
			drawRes = new DrawStringResult(0,0,0);
		}
		if(aci != null) {
			drawRes.chars = aci.getEndIndex();
		}
		if(aci == null || (aci.getEndIndex() == 1 && aci.first() == ' ')) {
			drawRes.chars = 0;
		}
		return drawRes;
	}*/
}
