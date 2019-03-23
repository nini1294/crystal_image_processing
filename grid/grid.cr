require "stumpy_png"
require "stumpy_utils"
include StumpyPNG

WIDTH  = 512
HEIGHT = 512

canvas = Canvas.new(WIDTH, HEIGHT) do |x, y|
  RGBA.from_rgb_n(x * 8, 512, 256, 9)
end

StumpyPNG.write(canvas, "grid.png")
