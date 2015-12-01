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
  @[(x: 0.0, y: 0.0), (x: 10.0, y: 10.0), (x: 20.0, y: 10.0),
    (x: 60.0, y: 300.0), (x: 100.0, y: 200.0)]
)

gxy.title = "Dependency of Y from X"
gxy.labelY = "Y"
gxy.labelX = "X"
wnd.addSubview(gxy)

runUntilQuit()
```

(https://photo1.space.zeo.net/bJk_iA30l3ULLZ0FHic2OQ==/5/1x1/origin/plotxy_example.png/565d/58/6d/565d586dac2a49262f04f0ff-565d586dac2a49262f04f100)
