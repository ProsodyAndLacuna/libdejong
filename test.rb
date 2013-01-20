require 'yaml'
require './lib/libdejong'

g = LibDeJong::Generator.new

160.upto(160) do |x|
  0.upto(g.image_size) do |y|
    p = LibDeJong::Point.new x, y
    f = nil
    unless g.frame_exists? p
      puts "Generating #{x},#{y}"
      f = g.generate_frame( LibDeJong::Point.new( x, y ) )
      LibDeJong::FrameWriter.write_raw(f)
    end
    f = LibDeJong::FrameWriter.read_raw g.frame_filename p if f.nil?

    LibDeJong::FrameWriter.write f
  end
end

#f = g.generate_frame( LibDeJong::Point.new(160.0, 5.0) )

#YAML::dump(f)

#LibDeJong::FrameWriter.write_raw(f)

#f = LibDeJong::FrameWriter.read_raw('dejong-640-160.0-005.0.json')

#puts f.current

#f.compute_frame(f.current, 300000)

#LibDeJong::FrameWriter.write f



