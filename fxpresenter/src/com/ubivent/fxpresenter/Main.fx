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

package com.ubivent.fxpresenter;

import javafx.stage.Stage;
import javafx.scene.Scene;
import com.ubivent.fxpresenter.dom.PDocument;
import com.ubivent.fxpresenter.dom.UnknownElement;
import javafx.scene.Node;
import javafx.animation.transition.ParallelTransition;
import javafx.animation.transition.TranslateTransition;
import javafx.animation.transition.ScaleTransition;
import javax.swing.JFileChooser;
import javafx.scene.shape.Rectangle;
import javafx.scene.input.KeyCode;
import javafx.scene.transform.Scale;

/**
 * FXPresenter test class
 * @author thomasbutter
 */

var chooser = new JFileChooser();
chooser.showOpenDialog(null);

var pdoc = PDocument.createFromODP(chooser.getSelectedFile());
UnknownElement.print();

var current : Node = null;
var next : Node = null;
var node : Rectangle = null;
var nodeFocus = bind node.focused on replace {
    if(not nodeFocus) node.requestFocus();
};

var transitioning : Boolean = false;

var page : Integer = -1 on replace {
    if(not transitioning and pdoc != null and page >= 0) {
        transitioning = true;
        next = pdoc.getPages()[page].createNode();
        fitToScene(stage.scene, next);
        current.cache = true;
        ParallelTransition {
            content: [
                TranslateTransition {
                    duration: 1s
                    node: current
                    byY: - stage.scene.width
                },
                ScaleTransition {
                    duration: 1s
                    node: current
                    toX: 0.5
                    toY: 0.5
                }
                    ]
            action: function() {
                var tmp = next;
                next = null;
                current = tmp;
                transitioning = false;
            }
        }.play();
    }
}

var stage : Stage = Stage {
    title: "fxpresenter"
    scene: Scene {
        width: 800
        height: 600
        content: bind [
            next, current,
            node = Rectangle {
                focusTraversable: true
                onKeyReleased: function(evt) {
                    if(transitioning) return;
                    var tmppage = page;
                    if(evt.code == KeyCode.VK_SPACE) tmppage++
                    else if(evt.code == KeyCode.VK_BACK_SPACE) tmppage--
                    else if(evt.code == KeyCode.VK_Q or evt.code == KeyCode.VK_ESCAPE) FX.exit()
                    else if(evt.code == KeyCode.VK_F) stage.fullScreen = not stage.fullScreen;
                    if(page < 0) tmppage = sizeof pdoc.getPages()-1;
                    if(page >= sizeof pdoc.getPages()) tmppage = 0;
                    page = tmppage;
                }
            }
        ]
    }
}

fitToScene(stage.scene, current);
var sceneWidth = bind stage.scene.width on replace {
    fitToScene(stage.scene, current);
}

var sceneHeight = bind stage.scene.height on replace {
    fitToScene(stage.scene, current);
}

page = 0;

function fitToScene(scene : Scene, node : Node) {
    var width = node.boundsInLocal.width;
    var height = node.boundsInLocal.height;
    var aspectRatio = width / height;
    var scale : Double = 1;
    if(scene.width / scene.height > aspectRatio) {
        scale = scene.height / height;
    } else {
        scale = scene.width / width;
    }
    node.layoutX = (scene.width - width * scale)/2;
    node.layoutY = (scene.height - height * scale)/2;
    node.transforms = Scale {
        x: scale
        y: scale
        pivotX: 0
        pivotY: 0
    }
}