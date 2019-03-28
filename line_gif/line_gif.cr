require "stumpy_gif"
require "stumpy_png"
require "stumpy_utils"

include StumpyGIF
include StumpyPNG

SEED = ARGV[0]? || 0
# SEED = 10
R = Random.new(SEED.to_i)

WIDTH  = 512
HEIGHT =  256
FRAMES = 60

Y0 = HEIGHT / 2

def create_lines()
  vals = [] of Float64
  last = R.rand * HEIGHT / 2
  delta = 0
  offset = 0.5
  countp = 0
  countm = 0
  (0..WIDTH).each do |x|
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
    delta = (R.rand - offset) * 4
    last = last + delta
    vals.push((last + delta))
    # puts vals[x]
  end
  return vals
end

def build_frame(lines, num)
  canvas = Canvas.new(WIDTH, HEIGHT, RGBA::GRAY)
  # canvas.line(0, Y0, WIDTH, Y0, RGBA::YELLOW);
  (0..WIDTH).each do |x|
    last = lines[x]
    frame_offset = num
    canvas.line(x, Y0, x, Y0 + last)
    if ((x + frame_offset) >= WIDTH)
      canvas.line(WIDTH - x, Y0, WIDTH - x, Y0 - lines[x - frame_offset], RGBA::RED)
    else
      canvas.line(x + frame_offset, Y0, x + frame_offset, Y0 - last, RGBA::WHITE)
    end
  end
  return canvas
end

frames = [] of Canvas
lines = create_lines()

FRAMES.times do |frame|
  StumpyPNG.write(build_frame(lines, frame), File.join(__DIR__, "lines_#{SEED}_#{frame}.png"))
end

puts "Done"