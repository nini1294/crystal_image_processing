NX = 600
NY = 300

File.open("basic.ppm", "w") do |f|
  f.puts "P3"
  f.puts "#{NX} #{NY}"
  f.puts "255"
  (0...NY).reverse_each do |y|
    (0...NX).each do |x|
      r = x / NX.to_f
      g = y / NY.to_f
      b = 0.2
      ir = (255.99 * r).to_i
      ig = (255.99 * g).to_i
      ib = (255.99 * b).to_i
      f.puts "#{ir} #{ig} #{ib}"
    end
  end
end
