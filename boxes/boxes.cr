require "stumpy_png"
require "stumpy_utils"

include StumpyPNG

SEED = ARGV[0]? || 0

# SEED = 10
R = Random.new(SEED.to_i)

WIDTH  = 512
HEIGHT =  512
N_BOXES = 8

OFFSET = 4
WB = WIDTH / N_BOXES
HB = HEIGHT / N_BOXES

x = 0
y = 0

canvas = Canvas.new(WIDTH, HEIGHT, RGBA::WHITE)

(0..N_BOXES).each do |y_ind|
  y0 = y + OFFSET
  y1 = HB * y_ind - OFFSET
  (0..N_BOXES).each do |x_ind|
    x0 = x + OFFSET
    x1 = WB * x_ind - OFFSET
    color = (x_ind + y_ind).even? ? RGBA::RED : RGBA::BLUE
    p x0, y0, x1, y1
    canvas.rect(x0, y0, x1, y1, color)
    x = x1
  end
  y = y1
end

StumpyPNG.write(canvas, File.join(__DIR__, "boxes_#{SEED}.png"))
