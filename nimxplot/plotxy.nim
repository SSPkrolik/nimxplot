import nimx.context
import nimx.control
import nimx.font

import dataxy

type PlotXY* = ref object of Control
  ## Plotting widgets that implements rendering of "y=f(x)" function.
  title*: string
  labelX*: string
  labelY*: string

  boundary*: float32
  gridstep*: float32

  model*: ModelXY[float64]

  modelBounds: tuple[minx: float64, maxx: float64, miny: float64, maxy: float64]
  scale: tuple[x: float64, y: float64]
  poly: seq[Coord]

method init(mxy: PlotXY, r: Rect) =
  procCall mxy.Control.init(r)
  mxy.backgroundColor = whiteColor()

  mxy.title = "Title"
  mxy.labelX = "X"
  mxy.labelY = "Y"
  mxy.boundary = 50.0
  mxy.gridstep = 15.0

  for point in mxy.model.items():
    mxy.modelBounds.minx = min(point.x, mxy.modelBounds.minx)
    mxy.modelBounds.miny = min(point.y, mxy.modelBounds.miny)
    mxy.modelBounds.maxx = max(point.x, mxy.modelBounds.maxx)
    mxy.modelBounds.maxy = max(point.y, mxy.modelBounds.maxy)

  mxy.scale.x = (r.width - mxy.boundary * 2) / (mxy.modelBounds.maxx - mxy.modelBounds.minx)
  mxy.scale.y = (r.height- mxy.boundary * 2) / (mxy.modelBounds.maxy - mxy.modelBounds.miny)

  mxy.poly = @[]
  for point in mxy.model.items():
    mxy.poly.add(mxy.boundary + Coord(point.x.float32) * mxy.scale.x)
    mxy.poly.add(Coord(r.height) - Coord(point.y.float32) * mxy.scale.y - mxy.boundary)

proc newPlotXY*(r: Rect, model: ModelXY[float64]): PlotXY =
  result.new()
  result.model = model
  result.init(r)

method draw(mxy: PlotXY, r: Rect) =
  procCall mxy.View.draw(r)

  let c = currentContext()

  ## Draw grid
  c.strokeColor = newGrayColor(0.7)
  c.strokeWidth = 1

  for i in 0..mxy.gridstep.int:
    let
      pStart = newPoint(mxy.boundary, r.size.height - mxy.boundary - i.float32 * (r.size.height - mxy.boundary * 2) / mxy.gridstep)
      pEnd = newPoint(r.size.width - mxy.boundary, r.size.height - mxy.boundary - i.float32 * (r.size.height - mxy.boundary * 2) / mxy.gridstep)
    c.drawLine(pStart, pEnd)

  for i in 0..mxy.gridstep.int:
    let
      pStart = newPoint(mxy.boundary + i.float32 * (r.size.width - mxy.boundary * 2) / mxy.gridstep, mxy.boundary)
      pEnd = newPoint(mxy.boundary + i.float32 * (r.size.width - mxy.boundary * 2) / mxy.gridstep, r.size.height - mxy.boundary)
    c.drawLine(pStart, pEnd)

  ## Draw graph
  c.fillColor = blackColor()
  c.strokeColor = blackColor()
  c.strokeWidth = 2

  if not isNil(mxy.model):
    c.strokeColor = blackColor()
    for i in countup(0, mxy.poly.len()-3, 2):
      c.drawLine(
        newPoint(mxy.poly[i], mxy.poly[i+1]),
        newPoint(mxy.poly[i+2], mxy.poly[i+3])
      )
    c.strokeColor = newColor(1.0, 0.0, 0.0)
    c.fillColor = c.strokeColor
    for i in countup(0, mxy.poly.len()-3, 2):
      c.drawEllipseInRect(newRect(mxy.poly[i] - 3, mxy.poly[i+1] - 3, 6, 6))

  c.fillColor = blackColor()
  c.strokeColor = blackColor()
  let font = systemFont()

  ## Draw title
  var pt = centerInRect(font.sizeOfString(mxy.title), newRect(0.0, 0.0, r.size.width, mxy.boundary))
  c.drawText(font, pt, mxy.title)

  ## Draw axes labels
  pt = newPoint(mxy.boundary / 2, mxy.boundary / 2)
  c.drawText(font, pt, mxy.labelY)

  pt = newPoint(r.size.width - mxy.boundary * 2, r.size.height - mxy.boundary / 1.5)
  c.drawText(font, pt, mxy.labelX)
