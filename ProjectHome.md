Integrate Open Document Presentations into your JavaFX Application. Currently only a minimal subset of ODP features is supported, but basic presentations already work.

Demo: [start](http://static.ubivent.com/fxpresenter.jnlp)

Select an ODP file

press
  * f for fullscreen
  * space - next page
  * backspace - previous page
  * q/esc - quit

usage in JavaFX application:

```
var pdoc = PDocument.createFromODP("filename.odp");
scene.content = pdoc.getPages()[pagenumber].createNode()
```