require 'yaml'
require './lib/libdejong'

g = LibDeJong::Generator.new (640 * 2)

30.upto(30) do |y|
  30.upto(g.image_size) do |x|
    p = LibDeJong::Point.new x, y
    f = nil
    unless g.frame_exists? p
      t1 = Time.now
      f = g.generate_frame( LibDeJong::Point.new( x, y ) )
      LibDeJong::FrameWriter.write_raw(f)
      #LibDeJong::FrameWriter.write_zip(f)
      puts "Generated #{x},#{y} in #{Time.now - t1}"
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



