require "stumpy_png"
require "stumpy_utils"
include StumpyPNG

WIDTH  = 512
HEIGHT = 512

canvas = Canvas.new(WIDTH, HEIGHT)

(0...WIDTH).each do |x|
  (0...HEIGHT).each do |y|
    # RGBA.from_rgb_n(values, bit_depth) is an internal helper method
    # that creates an RGBA object from a rgb triplet with a given bit depth
    color = RGBA.from_rgb_n(x / 2, y / 2, ARGV[0].to_i, 8)
    canvas[x, y] = color
  end
end

StumpyPNG.write(canvas, "rainbow.png")
