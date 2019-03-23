require "stumpy_png"
require "stumpy_utils"
include StumpyPNG

WIDTH = 1024
HEIGHT = 1024
PADDING = WIDTH / 16 + HEIGHT / 16

N_POINTS = 20

POINT_RADIUS = 2
LINE_COLORS = [RGBA::RED, RGBA::BLUE, RGBA::GREEN]
FILL_COLORS = [
  RGBA.from_hex("#933BCF"),
  RGBA.from_hex("#F15F76"),
  RGBA.from_hex("#F76D3C"),
  RGBA.from_hex("#F7D842"),
  RGBA.from_hex("#2CA8C2"),
  RGBA.from_hex("#98CB4A"),
  RGBA.from_hex("#839098"),
  RGBA.from_hex("#5481E8"),
]

SEED = ARGV[0]? || 0
R = Random.new(SEED.to_i)
TWO_COLORS = Array.new(2) { |_| FILL_COLORS[R.rand(FILL_COLORS.size)] }

struct StumpyCore::Point
  # property x, y

  # def initialize(@x : Int32, @y : Int32)
  # end

  def to_s(io)
    io << "x: #{x}, y: #{y}"
  end

  def distance(p2 : StumpyCore::Point)
    Math.sqrt((x - p2.x)**2 + (y - p2.y)**2)
  end
end

def generate_points(num) 
  px = Array.new(num) do |index|
    R.rand(PADDING..(WIDTH-PADDING)).to_f
  end
  py = Array.new(num) do |index|
    R.rand(PADDING..(HEIGHT-PADDING)).to_f
  end

  px.zip(py).map { |x, y| Point.new(x, y) }
end

points = generate_points(N_POINTS) 

distances = Hash(Point, Array(Tuple(Point, Float64))).new(N_POINTS) {Array(Tuple(Point, Float64)).new(10)}
count = 0
points.each_permutation(2) do |pts|
  p1_index = count / N_POINTS
  p2_index = count % N_POINTS
  p1, p2 = pts
  # puts "#{p1_index}: #{p1} || #{p2_index}: #{p2}"
  distances[p1] = distances[p1].push({p2, p1.distance(p2)})

  count += 1
end
# puts count

canvas = Canvas.new(WIDTH, HEIGHT, RGBA::WHITE)

points.each_with_index do |p, i|
  sorted = distances[p].sort_by do |v|
    v[1]
  end.map do |p|
    p[0]
  end
  
  sorted[0..2].each_with_index do |p2, index|
    canvas.line(p.x, p.y, p2.x, p2.y, LINE_COLORS[index])
  end

  vert = sorted[0..1].push(p)
  canvas.fill_polygon(vert, TWO_COLORS.first.mix(TWO_COLORS.last, i.to_f / N_POINTS))

  canvas.circle(p.x, p.y, POINT_RADIUS, RGBA::BLACK, filled = true)
end

StumpyPNG.write(canvas, File.join(__DIR__, "polygons_#{SEED}.png"))