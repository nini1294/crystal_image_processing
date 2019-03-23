require "stumpy_png"
require "stumpy_utils"
include StumpyPNG

WIDTH  = 1024
HEIGHT = 1024

BG_COLOR   = RGBA::WHITE
BLOB_COLOR = RGBA::BLACK

ITERATIONS = 10
HALF_MAX   = UInt16::MAX / 2

canvas_pre = Canvas.new(WIDTH, HEIGHT) do |x, y|
  chance = rand > 0.003
  chance ? BG_COLOR : BLOB_COLOR
end

StumpyPNG.write(canvas_pre, "blobs_pre.png")
# canvas_pre = StumpyPNG.read("blobs_pre.png")

canvas = Canvas.new(WIDTH, HEIGHT)

ITERATIONS.times do |iter|
  chance_count = 0
  ratio = (iter * 1.0) / ITERATIONS
  gray = HALF_MAX + (HALF_MAX * ratio)
  alpha = UInt16::MAX * ratio
  iter_color = RGBA.new(gray.round.to_u16)
  puts iter_color
  (0...WIDTH).each do |x|
    (0...HEIGHT).each do |y|
      if canvas_pre[x, y] == BG_COLOR
        surr = [
          canvas_pre.wrapping_get(x - 1, y),
          canvas_pre.wrapping_get(x + 1, y),
          canvas_pre.wrapping_get(x, y - 1),
          canvas_pre.wrapping_get(x, y + 1),
        ]
        count = surr.count { |p| p == BG_COLOR }
        chance_count += 1 if count <= 3
        canvas[x, y] = count <= 3 ? iter_color : BG_COLOR
      else
        canvas[x, y] = canvas[x, y]
      end
    end
  end
  canvas_pre.paste(canvas, 0, 0)
  puts chance_count
end

StumpyPNG.write(canvas, "blobs.png")
