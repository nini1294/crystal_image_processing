require "stumpy_png"
require "stumpy_utils"
include StumpyPNG

seed = ARGV[0].to_i

r = Random.new(seed)

WIDTH  = 1024
HEIGHT =  512

Y0 = HEIGHT / 2

canvas = Canvas.new(WIDTH, HEIGHT, RGBA::GRAY)
# canvas.line(0, Y0, WIDTH, Y0, RGBA::YELLOW);
last = r.rand * HEIGHT / 4
delta = 0
offset = 0.5
countp = 0
countm = 0
(0..WIDTH).select(&.even?).each do |x|
  if delta > 0
    countp += 1
    countm = 0
    # puts "Plus:  #{countp}"
    offset = 0.10
  elsif delta < 0
    countm += 1
    countp = 0
    # puts "Minus: #{countm}"
    offset = 0.90
  end
  # offset = 0.5
  delta = (r.rand - offset) * 4
  last = (last + delta).round
  canvas.line(x, Y0, x, Y0 + last)
  canvas.line(x + 1, Y0, x + 1, Y0 - last, RGBA::WHITE)
end

StumpyPNG.write(canvas, File.join(__DIR__, "lines_#{seed}.png"))
