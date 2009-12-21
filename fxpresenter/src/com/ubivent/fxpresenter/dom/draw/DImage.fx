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
import com.ubivent.fxpresenter.dom.StyledElement;
import com.ubivent.fxpresenter.dom.style.Style;
import com.ubivent.fxpresenter.graphics.Length;
import java.lang.String;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.Node;
import javax.imageio.ImageIO;
import javafx.ext.swing.SwingUtils;


public class DImage extends PElement, StyledElement {

	postinit {
                nsURI = nsDRAW;
                nodeName = "draw:image";
	}

	function getImage() : Image {
		var href : String = getAttributeNS(nsXLINK, "href").value;
		if (href != null and href != "") {
                        var bimg = ImageIO.read(doc.getFileAsStream(href));
			return SwingUtils.toFXImage(bimg);
		}
		return null;
	}

	public function createNode(width : Length, height : Length) : Node[] {
		var img = getImage();
		if(img != null)
			return ImageView {
                            fitWidth: width.getAsPixel()
                            fitHeight: height.getAsPixel()
                            image: img
                        }
                return [];

	}

	public override function getStyleList() : Style[] {
		var ret = (parent as StyledElement).getStyleList();
		return ret;
	}
}
