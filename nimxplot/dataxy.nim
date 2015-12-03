## Data model for plotting
import nimx.types

type ModelXY*[T] = seq[tuple[x: T, y: T]]
  ## y=f(x) discrete data model

type ModelXYColor*[T] = seq[tuple[x: T, y: T, color: Color]]
  ## t=f(x) discrete data model with colored dots
