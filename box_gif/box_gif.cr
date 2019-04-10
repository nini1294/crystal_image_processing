require "stumpy_gif"
require "stumpy_png"
require "stumpy_utils"

include StumpyGIF
include StumpyPNG

SEED = ARGV[0]? || 0
FRAMES = ARGV[1]? || 30

# SEED = 10
R = Random.new(SEED.to_i)

WIDTH  = 512
HEIGHT =  512

W4 = WIDTH / 4
H4 = HEIGHT / 4

def build_frame(num)
  # puts num
  inc = num
  canvas = Canvas.new(WIDTH, HEIGHT, RGBA::WHITE)
  canvas.fill_rect(W4, H4, 3 * W4, 3 * H4)
  canvas.fill_rect(inc + W4 / 2, inc + H4 / 2, W4 + 3 * W4 / 2, H4 + 3 * H4 / 2, RGBA::RED)
  canvas.fill_rect(W4 * 2 - inc, H4 * 2 - inc, W4 / 2 + 3 * W4, H4 / 2 + 3 * H4, RGBA::BLUE)
  canvas.rect(W4 - 1, H4 - 1, 3 * W4 + 1, 3 * H4 + 1, RGBA::WHITE)
  canvas.rect(W4 - 5, H4 - 5, 3 * W4 + 5, 3 * H4 + 5, RGBA::WHITE)
  return canvas
end

frames = [] of Canvas

FRAMES.to_i.times do |frame|
  f = build_frame(frame)
  StumpyPNG.write(f, File.join(__DIR__, "boxes_#{SEED}_#{frame}.png"))
  frames << f
end