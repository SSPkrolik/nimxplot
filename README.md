# nimxplot

Plotting library and widgets for nimx Nim GUI framework

## Dependencies and Installation

 * `Nim >= 0.10.0`
 * `nimx`

```bash
nimble install nimx
nimble install https://github.com/SSPkrolik/nimxplot.git
```

## Usage

```nim
## Desktop usage example

import nimx.sdl_window
import nimx.types

import nimxplot.dataxy
import nimxplot.plotxy

var wnd: SdlWindow

wnd.new()
wnd.init(newRect(40, 40, 1024, 768))

var gxy = newPlotXY(
  newRect(0, 0, 1024, 768),
  @[(x: 0.0, y: 0.0, color: blackColor()), (x: 10.0, y: 10.0, color: blackColor()), (x: 20.0, y: 10.0, color: blackColor()),
    (x: 60.0, y: 300.0, color: blackColor()), (x: 100.0, y: 200.0, color: blackColor())]
)

gxy.title = "Dependency of Y from X"
gxy.labelY = "Y"
gxy.labelX = "X"
wnd.addSubview(gxy)

runUntilQuit()
```

![Example of PlotXY](http://i.imgur.com/QScB5Cv.png?1)
